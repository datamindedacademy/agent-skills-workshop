#!/usr/bin/env python3
"""Put a track's skeletons into the chosen difficulty mode.

    python3 .claude/skills/sorting-hat/set-mode.py <track> <guided|challenge|expert>

guided     leave the skeletons as they are (all TODO guidance intact)
challenge  strip the guidance, keep the structure: headings, numbered steps and
           the frontmatter fields survive; every hint collapses to a bare TODO
expert     as challenge, and drop the body too, except sections marked "(given)"

Refuses to touch a file that no longer looks like a fresh skeleton, so re-running
it can't eat work in progress.
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
TRACKS = ("data-engineer", "data-analyst", "data-steward")
MODES = ("guided", "challenge", "expert")

HINT_LINE = re.compile(r"^\s*#")                       # frontmatter guidance
TODO_HEAD = re.compile(r"^(\s*(?:\d+\.\s+)?)TODO \d+:")  # body guidance paragraph
GIVEN = re.compile(r"^#{2,}\s.*\(given\)\s*$", re.I)


def _split(text):
    """--- frontmatter --- / body"""
    m = re.match(r"^---\n(.*?\n)---\n(.*)$", text, re.S)
    if not m:
        raise ValueError("no YAML frontmatter")
    return m.group(1), m.group(2)


def _strip_comment_blocks(lines):
    out, skipping = [], False
    for line in lines:
        if not skipping and "<!--" in line:
            skipping = True
        if skipping:
            if "-->" in line:
                skipping = False
            continue
        out.append(line)
    return out


def _collapse_todos(lines):
    """`2. TODO 4: long explanation…` -> `2. TODO`, dropping its continuation."""
    out, skipping = [], False
    for line in lines:
        m = TODO_HEAD.match(line)
        if m:
            out.append(m.group(1) + "TODO")
            skipping = True
            continue
        if skipping:
            if line.strip():
                continue
            skipping = False
        out.append(line)
    return out


def _drop_body(lines):
    """expert: keep the H1 and any '(given)' section, drop the rest."""
    out, keeping = [], True
    for line in lines:
        if line.startswith("#"):
            keeping = line.startswith("# ") or bool(GIVEN.match(line))
        if keeping:
            out.append(line)
    return out


def rewrite(text, mode):
    front, body = _split(text)
    front_lines = [l for l in front.split("\n") if not HINT_LINE.match(l)]
    body_lines = _collapse_todos(_strip_comment_blocks(body.split("\n")))
    if mode == "expert":
        body_lines = _drop_body(body_lines)
    out = "---\n" + "\n".join(front_lines).strip("\n") + "\n---\n" + "\n".join(body_lines)
    return re.sub(r"\n{3,}", "\n\n", out).rstrip("\n") + "\n"


def skeletons(track):
    return sorted((ROOT / "exercises" / track).glob("*/.claude/skills/*/SKILL.md"))


def main(track, mode):
    if track not in TRACKS or mode not in MODES:
        sys.exit(f"usage: set-mode.py <{'|'.join(TRACKS)}> <{'|'.join(MODES)}>")
    files = skeletons(track)
    if not files:
        sys.exit(f"no skeletons found for track {track}")
    for f in files:
        rel = f.relative_to(ROOT)
        text = f.read_text()
        if mode == "guided":
            print(f"guided:    {rel} (unchanged)")
            continue
        if "TODO 1:" not in text:
            print(f"skipped:   {rel} (already edited — not a fresh skeleton)")
            continue
        f.write_text(rewrite(text, mode))
        print(f"{mode}: {rel}")
    print(f"\nMode: {mode}. `git checkout exercises/{track}` restores the guided skeletons.")


def _selfcheck():
    for track in TRACKS:
        for f in skeletons(track):
            src = f.read_text()
            for mode in ("challenge", "expert"):
                got = rewrite(src, mode)
                assert "<!--" not in got, (f, mode)
                assert "TODO 1:" not in got, (f, mode)
                assert re.search(r"^description: TODO$", got, re.M), (f, mode)
                assert re.search(r"^allowed-tools: TODO$", got, re.M), (f, mode)
                assert re.search(r"^name: [a-z-]+$", got, re.M), (f, mode)
                if mode == "challenge":  # expert drops the body outright
                    assert "TODO" in got.split("---\n")[2], (f, mode)
    print("selfcheck ok")


if __name__ == "__main__":
    if sys.argv[1:2] == ["--selfcheck"]:
        _selfcheck()
    else:
        main(*sys.argv[1:3])
