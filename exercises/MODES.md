# Difficulty modes

The TODO comments in a skill skeleton are the scaffolding. Less scaffolding,
more difficulty — the tests and the stage's "Done when" checklist are identical
in all three modes.

| Mode | What your skeleton holds |
|---|---|
| Guided | The skeleton with all its TODO hints. Work them in order. |
| Challenge | Headings and numbered steps only — every hint stripped. Build from the "Done when" checklist. |
| Expert | Just the frontmatter and any reference marked "(given)". Write the skill from scratch. |

The Sorting Hat asked how much you'd built with skills before and set your
track up accordingly, so there's nothing to do before you start.

## Switching mode

From your stage folder:

```bash
uv run ../../../.claude/skills/sorting-hat/set-mode.py <track> <guided|challenge|expert>
```

It only ever strips a *fresh* skeleton. Once you've started writing, it leaves
your file alone and says so — so switching up a level mid-exercise won't eat
your work, and it can't put hints back either.

To go back down a level, restore the original skeleton from git:

```bash
git checkout .claude
```
