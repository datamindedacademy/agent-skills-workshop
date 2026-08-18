# Stage 1: Build `data-product-checkup` (45 min)

Run `checkup` on the warehouse and report a clear health scorecard.

1. Open `.claude/skills/data-product-checkup/SKILL.md` and `checkup.yaml` (both
   in this folder), and work the TODOs in order (the metrics live in
   `checkup.yaml`, the rest in the SKILL).
2. Test it:
   ```bash
   claude
   # then: /data-product-checkup
   ```

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
