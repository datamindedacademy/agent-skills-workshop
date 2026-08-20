# Stage 2: Add subagents, `multi-panel-report` (60 min)

Each report section is a small investigation: you poke, notice something, chase
it, then write the paragraph. Give each section its own subagent to do that
digging, in parallel, and assemble their findings.

1. Open `.claude/skills/multi-panel-report/SKILL.md` and work the TODOs in order.
2. Test it:
   ```bash
   claude
   # then: /multi-panel-report
   ```

> **Tip:** editing the skill while a `claude` session is open? Run
> `/reload-skills` in that session to pick up your changes.

Fanning out here buys focus. A real investigation throws off a lot of dead-end
queries; run three of them in one window and the threads tangle.
Each subagent keeps its own mess to itself and hands back a clean paragraph. A
single question doesn't need any of that, so answer it inline like Stage 1 did.

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
bash tests/test-multi-panel-report.sh
```

It verifies the structure and then hands you the behavioural test. You're done
when all three hold:

- [ ] `/multi-panel-report` visibly runs the section subagents **at the same
      time** — several Agent calls in one message, not one after another.
- [ ] The report has all three panels plus an executive summary that connects
      findings **across** sections, and one merged caveats line.
- [ ] The counter-test: a single question ("how many customers?") does **not**
      fan out — one query answers it.

## Challenge: cheapest passing report

Measure on **clean context** — `/clear` first. Not `/compact`: compaction costs
tokens itself and leaves a summary behind, so the number stops being comparable.

```
/clear
/cost                  # baseline
/multi-panel-report
/cost                  # delta = what one run of your skill costs
```

Now make that delta smaller without failing the checklist. What moves it:

- a tight brief per subagent — vague instructions buy exploratory queries
- what each subagent **returns**: a paragraph, not its working
- a smaller model for the *subagents* — cheap diggers, capable synthesizer
- an exact output spec — no re-drafting the report

Lowest output-token run that still passes the "Done when" checks wins.
