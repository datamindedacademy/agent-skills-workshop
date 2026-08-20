#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = []
# ///
"""Put a track's skill skeletons into the chosen difficulty mode.

    uv run .claude/skills/sorting-hat/set-mode.py <track> <guided|challenge|expert>

guided     leave the skeletons as they are (all TODO guidance intact)
challenge  strip the guidance, keep the structure: headings, numbered steps and
           the frontmatter fields survive; every hint collapses to a bare TODO
expert     as challenge, and drop the body too, except sections marked "(given)"

Refuses to touch a file that no longer looks like a fresh skeleton, so re-running
it can't eat work in progress.
"""

import argparse
import re
import sys
from pathlib import Path

MODES = ("guided", "challenge", "expert")

HINT_LINE = re.compile(r"^\s*#")                         # frontmatter guidance
TODO_HEAD = re.compile(r"^(\s*(?:\d+\.\s+)?)TODO \d+:")  # body guidance paragraph
GIVEN = re.compile(r"^#{2,}\s.*\(given\)\s*$", re.IGNORECASE)
FRONTMATTER = re.compile(r"^---\n(.*?\n)---\n(.*)$", re.DOTALL)


def repo_root() -> Path:
    for d in Path(__file__).resolve().parents:
        if (d / "exercises").is_dir():
            return d
    sys.exit("set-mode.py: no exercises/ directory above this script")


def tracks() -> list[str]:
    return sorted(d.name for d in (repo_root() / "exercises").iterdir() if d.is_dir())


def skeletons(track: str) -> list[Path]:
    return sorted((repo_root() / "exercises" / track).glob("*/.claude/skills/*/SKILL.md"))


def drop_comment_blocks(lines: list[str]) -> list[str]:
    out, skipping = [], False
    for line in lines:
        skipping = skipping or "<!--" in line
        if not skipping:
            out.append(line)
        elif "-->" in line:
            skipping = False
    return out


def collapse_todos(lines: list[str]) -> list[str]:
    """`2. TODO 4: long explanation…` -> `2. TODO`, dropping its continuation."""
    out, skipping = [], False
    for line in lines:
        if match := TODO_HEAD.match(line):
            out.append(match[1] + "TODO")
            skipping = True
        elif skipping and line.strip():
            continue
        else:
            skipping = False
            out.append(line)
    return out


def keep_given_only(lines: list[str]) -> list[str]:
    """expert: keep the H1 and any '(given)' section, drop the rest."""
    out, keeping = [], True
    for line in lines:
        if line.startswith("#"):
            keeping = line.startswith("# ") or bool(GIVEN.match(line))
        if keeping:
            out.append(line)
    return out


def rewrite(text: str, mode: str) -> str:
    parts = FRONTMATTER.match(text)
    if not parts:
        raise ValueError("no YAML frontmatter")
    front, body = parts.groups()

    kept_front = [l for l in front.splitlines() if not HINT_LINE.match(l)]
    kept_body = collapse_todos(drop_comment_blocks(body.splitlines()))
    if mode == "expert":
        kept_body = keep_given_only(kept_body)

    out = "---\n{}\n---\n{}".format("\n".join(kept_front).strip("\n"), "\n".join(kept_body))
    return re.sub(r"\n{3,}", "\n\n", out).rstrip("\n") + "\n"


def set_mode(track: str, mode: str) -> None:
    files = skeletons(track)
    if not files:
        sys.exit(f"set-mode.py: no skill skeletons under exercises/{track}")
    for path in files:
        rel = path.relative_to(repo_root())
        text = path.read_text()
        if mode == "guided":
            print(f"guided:    {rel} (unchanged)")
        elif "TODO 1:" not in text:
            print(f"skipped:   {rel} (already edited — not a fresh skeleton)")
        else:
            path.write_text(rewrite(text, mode))
            print(f"{mode}: {rel}")
    print(f"\nMode: {mode}. `git checkout exercises/{track}` restores the guided skeletons.")


def selfcheck() -> None:
    """Every skeleton survives every mode with usable frontmatter and no leaked hints."""
    checked = 0
    for track in tracks():
        for path in skeletons(track):
            source = path.read_text()
            for mode in ("challenge", "expert"):
                got = rewrite(source, mode)
                where = (path.name, mode)
                assert "<!--" not in got, where
                assert "TODO 1:" not in got, where
                for field in ("name: [a-z-]+", "description: TODO", "allowed-tools: TODO"):
                    assert re.search(rf"^{field}$", got, re.MULTILINE), (where, field)
                if mode == "challenge":  # expert drops the body outright
                    assert "TODO" in FRONTMATTER.match(got)[2], where
                checked += 1
    print(f"selfcheck ok ({checked} rewrites)")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("track", nargs="?", choices=tracks())
    parser.add_argument("mode", nargs="?", choices=MODES)
    parser.add_argument("--selfcheck", action="store_true", help="verify all skeletons, change nothing")
    args = parser.parse_args()

    if args.selfcheck:
        selfcheck()
    elif args.track and args.mode:
        set_mode(args.track, args.mode)
    else:
        parser.error("give both a track and a mode (or --selfcheck)")


if __name__ == "__main__":
    main()
