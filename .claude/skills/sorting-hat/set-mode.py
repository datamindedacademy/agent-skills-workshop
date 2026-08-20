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
TODO_HEAD = re.compile(r"^([ \t]*(?:[-*][ \t]+|\d+\.[ \t]+)?)TODO[ \t]*\d*[ \t]*:")  # body guidance
HINT_LEFT = re.compile(r"TODO[ \t]*\d")                  # a hint we failed to strip
GIVEN = re.compile(r"^#{2,}\s.*\(given\)\s*$", re.IGNORECASE)
FRONTMATTER = re.compile(r"^---\n(.*?\n)---\n(.*)$", re.DOTALL)
FENCE = re.compile(r"^\s*(```|~~~)")


class SkeletonError(Exception):
    """The file isn't a skeleton we know how to strip."""


def find_repo_root() -> Path:
    for d in Path(__file__).resolve().parents:
        if (d / "exercises").is_dir():
            return d
    sys.exit("set-mode.py: no exercises/ directory above this script")


ROOT = find_repo_root()


def skeletons(track: str) -> list[Path]:
    return sorted((ROOT / "exercises" / track).glob("*/.claude/skills/*/SKILL.md"))


def tracks() -> list[str]:
    """Track directories that actually hold skill skeletons."""
    return sorted(d.name for d in (ROOT / "exercises").iterdir() if d.is_dir() and skeletons(d.name))


def in_fence(lines: list[str]) -> list[bool]:
    """Per line: is it inside (or is) a fenced code block?

    Markdown inside a fence is literal — a bash `# comment` is not a heading and
    a `<!--` is not a comment block. Every pass below skips fenced lines, so a
    code example can never be mistaken for structure.
    """
    flags, inside = [], False
    for line in lines:
        if FENCE.match(line):
            flags.append(True)
            inside = not inside
        else:
            flags.append(inside)
    return flags


def drop_comment_blocks(lines: list[str]) -> list[str]:
    out, skipping = [], False
    for line, fenced in zip(lines, in_fence(lines), strict=True):
        if not skipping and not fenced and "<!--" in line:
            skipping = True
        if not skipping:
            out.append(line)
        elif "-->" in line:
            skipping = False
    if skipping:
        raise SkeletonError("unterminated <!-- comment: refusing to drop the rest of the file")
    return out


def collapse_todos(lines: list[str]) -> list[str]:
    """`2. TODO 4: long explanation…` -> `2. TODO`, dropping its continuation."""
    out, skipping = [], False
    for line, fenced in zip(lines, in_fence(lines), strict=True):
        if not fenced and (match := TODO_HEAD.match(line)):
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
    for line, fenced in zip(lines, in_fence(lines), strict=True):
        if not fenced and line.startswith("#"):
            keeping = line.startswith("# ") or bool(GIVEN.match(line))
        if keeping:
            out.append(line)
    return out


def rewrite(text: str, mode: str) -> str:
    parts = FRONTMATTER.match(text)
    if not parts:
        raise SkeletonError("no YAML frontmatter")
    front, body = parts.groups()

    kept_front = [line for line in front.splitlines() if not HINT_LINE.match(line)]
    kept_body = collapse_todos(drop_comment_blocks(body.splitlines()))
    if mode == "expert":
        kept_body = keep_given_only(kept_body)

    out = "---\n{}\n---\n{}".format("\n".join(kept_front).strip("\n"), "\n".join(kept_body))
    out = re.sub(r"\n{3,}", "\n\n", out).rstrip("\n") + "\n"

    # The whole point is that no guidance survives. If some hint used a shape we
    # don't recognise, say so loudly rather than hand over a half-stripped file.
    if leaked := HINT_LEFT.search(out):
        line = out[: leaked.start()].count("\n") + 1
        raise SkeletonError(f"guidance survived stripping at line {line}: {leaked.group()!r}")
    return out


def is_fresh(text: str) -> bool:
    """A skeleton nobody has started on still carries its numbered hints."""
    return bool(HINT_LEFT.search(text))


def set_mode(track: str, mode: str) -> None:
    for path in skeletons(track):
        rel = path.relative_to(ROOT)
        text = path.read_text()
        if not is_fresh(text):
            # Either already stripped, or the participant has been working here.
            note = "already stripped" if mode != "guided" else "no hints left"
            print(f"  skipped  {rel} ({note} — `git checkout -- {rel}` restores it)")
        elif mode == "guided":
            print(f"  guided   {rel} (unchanged)")
        else:
            try:
                path.write_text(rewrite(text, mode))
            except SkeletonError as exc:
                sys.exit(f"set-mode.py: {rel}: {exc}")
            print(f"  {mode:<8} {rel}")
    print(f"\nMode: {mode}. `git checkout exercises/{track}` restores the guided skeletons.")


FIXTURE = """\
---
name: fixture
# TODO 1: hint in the frontmatter
description: TODO
allowed-tools: TODO
---

# Fixture

## Steps

1. TODO 2: a hint paragraph
   spilling onto a second line.

```bash
# not a heading, and this fence must survive verbatim
echo "<!-- not a comment block -->"
```

## Output format

<!--
TODO 3: a comment-block hint.
-->
"""


def check_fixture() -> None:
    """Markdown inside a fence is literal — stripping must not touch it."""
    got = rewrite(FIXTURE, "challenge")
    assert "# not a heading" in got, "fenced bash comment was eaten"
    assert 'echo "<!-- not a comment block -->"' in got, "fenced pseudo-comment was eaten"
    assert "1. TODO\n" in got, f"hint paragraph not collapsed:\n{got}"
    assert "hint paragraph" not in got and "hint in the frontmatter" not in got, got
    assert "## Output format" in got, "heading lost with its comment block"
    for bad, why in ((FIXTURE.replace("---\n\n# Fixture", ""), "no frontmatter"),
                     (FIXTURE.replace("-->", ""), "unterminated comment")):
        try:
            rewrite(bad, "challenge")
        except SkeletonError:
            continue
        raise AssertionError(f"{why} should have raised")


def selfcheck() -> None:
    """Every skeleton survives every mode with usable frontmatter and no leaked hints."""
    check_fixture()
    checked = 0
    for track in tracks():
        for path in skeletons(track):
            source = path.read_text()
            assert is_fresh(source), f"{path} is not a fresh skeleton"
            for mode in ("challenge", "expert"):
                got = rewrite(source, mode)  # raises if any guidance leaked through
                where = (path.name, mode)
                assert "<!--" not in got, where
                for field in ("name: [a-z-]+", "description: TODO", "allowed-tools: TODO"):
                    assert re.search(rf"^{field}$", got, re.MULTILINE), (where, field)
                if mode == "challenge":  # expert drops the body outright
                    assert "TODO" in FRONTMATTER.match(got)[2], where
                checked += 1
    print(f"selfcheck ok ({checked} rewrites across {len(tracks())} tracks)")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("track", nargs="?", choices=tracks())
    parser.add_argument("mode", nargs="?", choices=MODES)
    parser.add_argument("--selfcheck", action="store_true", help="verify every skeleton, change nothing")
    args = parser.parse_args()

    if args.selfcheck:
        selfcheck()
    elif args.track and args.mode:
        set_mode(args.track, args.mode)
    else:
        parser.error("give both a track and a mode (or --selfcheck)")


if __name__ == "__main__":
    main()
