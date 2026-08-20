# Stage 2: Add subagents, `remediate-products` (60 min)

Stage 1's scorecard told you which checks the warehouse fails. Now fix them. Each
failing check (missing descriptions, missing tests) is its own job, so hand each
to a subagent that drafts the fixes, and assemble them into a single diff you
review.

1. Open `.claude/skills/remediate-products/SKILL.md` and work the TODOs in order.
2. Test it:
   ```bash
   claude
   # then: /remediate-products
   ```

> **Tip:** editing the skill while a `claude` session is open? Run
> `/reload-skills` in that session to pick up your changes.

With one data product, we fan out over its failing *checks*. In a real org you'd
more often have many data products and fan out one subagent per product, running
this whole skill across each; here we show the same pattern on what we have.
Either way the wrinkle is the same: the subagents draft in parallel but *don't*
write (they share one schema file), and you make the single careful merge at the
end. Fan out the thinking, centralize the change.

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
bash tests/test-remediate-products.sh
```

It verifies the structure and then hands you the behavioural test. You're done
when all three hold:

- [ ] One subagent per failing check runs, **visibly in parallel**, and each
      hands back a list of edits — neither touches `_marts.yml` itself.
- [ ] You're shown a single merged diff of `_marts.yml` **before** it's applied.
- [ ] Re-running checkup afterwards (`checkup run -c ../1-build/checkup.yaml`)
      shows the flagged metrics moved.

## Challenge: cheapest passing remediation

Measure on **clean context** — `/clear` first. Not `/compact`: compaction costs
tokens itself and leaves a summary behind, so the number stops being comparable.

```
/clear
/cost                  # baseline
/remediate-products
/cost                  # delta = what one run of your skill costs
```

Now make that delta smaller without failing the checklist. What moves it:

- a tight brief per subagent — vague instructions buy schema-wide re-reading
- what each subagent **returns**: the edits, not the reasoning behind them
- a smaller model for the *subagents* — cheap drafters, capable merger
- an exact output spec — no re-drafting the diff

Lowest output-token run that still passes the "Done when" checks wins.
