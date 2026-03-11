#!/usr/bin/env python3
"""Compare baseline and skill benchmark runs using ccusage.

Reads session IDs from a results directory, fetches token usage
via `ccusage session --json`, and prints a side-by-side comparison.

Usage:
    python3 compare.py <results_dir>
    python3 compare.py --help

The results_dir should contain:
    baseline_sessions.txt  — one session ID per line (from baseline runs)
    skill_sessions.txt     — one session ID per line (from skill runs)

These files are created by benchmark.sh, or you can create them manually
by copying session IDs from your Claude Code runs.
"""

import argparse
import json
import subprocess
import sys
from pathlib import Path
from statistics import mean, stdev


def get_ccusage_sessions() -> dict:
    """Fetch all session data from ccusage."""
    try:
        result = subprocess.run(
            ["npx", "ccusage", "session", "--json"],
            capture_output=True, text=True, timeout=30,
        )
    except FileNotFoundError:
        print("Error: 'npx' not found. Install Node.js first.", file=sys.stderr)
        sys.exit(1)
    except subprocess.TimeoutExpired:
        print("Error: ccusage timed out.", file=sys.stderr)
        sys.exit(1)

    if result.returncode != 0:
        print(f"Error running ccusage: {result.stderr}", file=sys.stderr)
        sys.exit(1)

    data = json.loads(result.stdout)

    # ccusage JSON format: { "type": "session", "data": [...], "summary": {...} }
    # or: { "sessions": [...], "totals": {...} }
    sessions = data.get("data") or data.get("sessions", [])

    # Index by session ID
    session_map = {}
    for s in sessions:
        sid = s.get("session") or s.get("sessionId", "")
        if sid:
            session_map[sid] = {
                "input_tokens": s.get("inputTokens", 0),
                "output_tokens": s.get("outputTokens", 0),
                "total_tokens": s.get("totalTokens", 0),
                "cost_usd": s.get("costUSD") or s.get("totalCost", 0.0),
            }
    return session_map


def load_session_ids(filepath: Path) -> list[str]:
    """Load session IDs from a text file (one per line)."""
    if not filepath.exists():
        return []
    return [line.strip() for line in filepath.read_text().splitlines() if line.strip()]


def collect_metrics(session_ids: list[str], session_map: dict) -> list[dict]:
    """Look up metrics for a list of session IDs."""
    results = []
    for sid in session_ids:
        if sid in session_map:
            results.append(session_map[sid])
        else:
            # Try partial match (session IDs may be truncated)
            matches = [k for k in session_map if sid in k or k in sid]
            if matches:
                results.append(session_map[matches[0]])
            else:
                print(f"Warning: Session '{sid}' not found in ccusage data.", file=sys.stderr)
    return results


def compute_stats(results: list[dict]) -> dict:
    """Compute average and standard deviation for metrics."""
    if not results:
        return {}

    metrics = ["input_tokens", "output_tokens", "total_tokens", "cost_usd"]
    stats = {}

    for metric in metrics:
        values = [r[metric] for r in results]
        stats[metric] = {
            "avg": mean(values),
            "std": stdev(values) if len(values) > 1 else 0.0,
        }

    return stats


def format_number(n: float) -> str:
    """Format a number with comma separators."""
    return f"{n:,.0f}" if n else "0"


def format_cost(n: float) -> str:
    """Format a cost in USD."""
    return f"${n:.2f}"


def format_reduction(baseline: float, skill: float) -> str:
    """Format the percentage reduction."""
    if baseline == 0:
        return "--"
    pct = ((skill - baseline) / baseline) * 100
    return f"{pct:+.1f}%"


def print_table(baseline_stats: dict, skill_stats: dict, n_baseline: int, n_skill: int):
    """Print a formatted comparison table."""
    rows = [
        ("Input tokens", "input_tokens", format_number),
        ("Output tokens", "output_tokens", format_number),
        ("Total tokens", "total_tokens", format_number),
        ("Cost (USD)", "cost_usd", format_cost),
    ]

    col_w = 24
    print()
    print(f"{'Metric':<20} {'Baseline (avg)':<{col_w}} {'With Skill (avg)':<{col_w}} {'Reduction':<12}")
    print("-" * (20 + col_w * 2 + 12))

    for label, key, formatter in rows:
        b_stat = baseline_stats.get(key, {"avg": 0, "std": 0})
        s_stat = skill_stats.get(key, {"avg": 0, "std": 0})

        b_str = formatter(b_stat["avg"])
        s_str = formatter(s_stat["avg"])

        if n_baseline > 1 and b_stat["std"] > 0:
            b_str += f" +/-{formatter(b_stat['std'])}"
        if n_skill > 1 and s_stat["std"] > 0:
            s_str += f" +/-{formatter(s_stat['std'])}"

        reduction = format_reduction(b_stat["avg"], s_stat["avg"])
        print(f"{label:<20} {b_str:<{col_w}} {s_str:<{col_w}} {reduction:<12}")

    print("-" * (20 + col_w * 2 + 12))
    print(f"{'Runs':<20} {n_baseline:<{col_w}} {n_skill:<{col_w}}")
    print()


def main():
    parser = argparse.ArgumentParser(
        description="Compare baseline and skill benchmark results using ccusage session data."
    )
    parser.add_argument(
        "results_dir",
        type=str,
        help="Directory containing baseline_sessions.txt and skill_sessions.txt.",
    )
    args = parser.parse_args()

    results_dir = Path(args.results_dir)
    if not results_dir.exists():
        print(f"Error: Results directory '{results_dir}' not found.", file=sys.stderr)
        sys.exit(1)

    baseline_ids = load_session_ids(results_dir / "baseline_sessions.txt")
    skill_ids = load_session_ids(results_dir / "skill_sessions.txt")

    if not baseline_ids and not skill_ids:
        print(
            "Error: No session IDs found.\n"
            "Expected baseline_sessions.txt and/or skill_sessions.txt in the results directory.\n"
            "\n"
            "To create these manually, run your baseline and skill Claude sessions,\n"
            "then put one session ID per line in each file.\n"
            "You can find session IDs by running: npx ccusage session",
            file=sys.stderr,
        )
        sys.exit(1)

    print("Fetching session data from ccusage...")
    session_map = get_ccusage_sessions()
    print(f"Found {len(session_map)} session(s) in ccusage data.")

    baseline_results = collect_metrics(baseline_ids, session_map)
    skill_results = collect_metrics(skill_ids, session_map)

    print(f"Matched {len(baseline_results)}/{len(baseline_ids)} baseline session(s).")
    print(f"Matched {len(skill_results)}/{len(skill_ids)} skill session(s).")

    baseline_stats = compute_stats(baseline_results)
    skill_stats = compute_stats(skill_results)

    if baseline_stats and skill_stats:
        print_table(baseline_stats, skill_stats, len(baseline_results), len(skill_results))
    elif baseline_stats:
        print("\nBaseline results only (no skill sessions found):")
        for key, stat in baseline_stats.items():
            print(f"  {key}: {stat['avg']:,.0f}")
    elif skill_stats:
        print("\nSkill results only (no baseline sessions found):")
        for key, stat in skill_stats.items():
            print(f"  {key}: {stat['avg']:,.0f}")


if __name__ == "__main__":
    main()
