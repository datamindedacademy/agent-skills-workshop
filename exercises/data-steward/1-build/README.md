# Stage 1: Build `data-product-checkup` (45 min)

Run `checkup` on the warehouse and report a clear health scorecard.

1. Open `.claude/skills/data-product-checkup/SKILL.md` and `checkup.yaml` (both
   in this folder), and work the TODOs in order (the metrics live in
   `checkup.yaml`, the rest in the SKILL).
2. The scorecard your skill reports:
   - one summary line: an overall health **grade (A–F)** plus a one-sentence verdict
   - a **metric table**: metric | value | status (✅ good / ⚠️ warn / ❌ bad)
   - the **top gaps** to fix, most impactful first

   That's the *what*; the exercise is writing a SKILL.md that produces it
   reliably (think: thresholds for the statuses, how the grade is derived).
3. Test it:
   ```bash
   claude
   # then: /data-product-checkup
   ```

> **Tip:** editing the skill while a `claude` session is open? Run
> `/reload-skills` in that session to pick up your changes.

## Pick your mode

The TODO comments in the skeleton are the scaffolding. Less scaffolding, more
difficulty — the tests and the "Done when" checklist are identical in all three.

| Mode | What you get |
|---|---|
| Guided | The skeleton with all its TODO hints. Work them in order. |
| Challenge | Headings and numbered steps only — every hint stripped. Build from the "Done when" checklist. |
| Expert | Just the frontmatter and any reference marked "(given)". Write the skill from scratch. |

The Sorting Hat already put your track in the mode you picked. To switch:

```bash
uv run ../../../.claude/skills/sorting-hat/set-mode.py <track> <guided|challenge|expert>
```

Going back down a level is `git checkout .claude` from this folder.

## Done when

Run the checker from this folder:

```bash
bash tests/test-data-product-checkup.sh
```

It verifies the structure (no TODOs, enough metrics, checkup runs clean) and
then hands you the behavioural test. You're done when all three hold:

- [ ] Asking "how healthy is our warehouse data product?" **without naming the
      skill** triggers it — that's your `description` doing its job.
- [ ] The scorecard opens with an overall grade and one summary sentence, then
      a metric table with ✅/⚠️/❌ statuses.
- [ ] The biggest gaps are listed first — something you could hand a colleague
      to act on.
- [ ] It still passes with `model: eu.anthropic.claude-haiku-4-5-20251001-v1:0`
      in the frontmatter (see Stretch below). A vague spec passes on Opus, where
      the model covers for it, and falls apart on Haiku.

## Challenge: cheapest passing skill

Measure on **clean context** — `/clear` first. Not `/compact`: compaction costs
tokens itself and leaves a summary behind, so the number stops being comparable.

```
/clear
/cost                    # baseline
/data-product-checkup
/cost                    # delta = what one run of your skill costs
```

Now make that delta smaller without failing the checklist. What moves it:

- a tight `description` — Claude stops hunting for when to fire
- a tight `allowed-tools` — no exploratory Read/Glob before the one command
- an exact output spec — no re-drafting the scorecard
- a smaller `model:` — same work, cheaper tokens

Lowest output-token run that still passes the "Done when" checks wins.

## Stretch: play with the model

A skill can pick its **own model** in the frontmatter: handy when a skill
doesn't need the big model (mechanical CLI wrapping, like this one) or needs
the biggest one (deep analysis). The override lasts while the skill is active;
your session model comes back on the next prompt.

```yaml
---
name: data-product-checkup
description: …
model: eu.anthropic.claude-haiku-4-5-20251001-v1:0   # ← try the small model
---
```

Run `/data-product-checkup` with each and compare:

| `model:` | What to watch |
|---|---|
| *(no field)* | Inherits the session model: Opus 4.8 here |
| `eu.anthropic.claude-sonnet-4-6` | Usually identical scorecard, noticeably faster |
| `eu.anthropic.claude-haiku-4-5-20251001-v1:0` | Fastest: is the grading and gap-ranking still sound? |

Run `/model` to see what's active. The interesting question isn't "which is
best" but **what's the smallest model your skill still works on**: that's the
one it should declare. (There's also an `effort:` field to dial reasoning up
or down on a given model.)
