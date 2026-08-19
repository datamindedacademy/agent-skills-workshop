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
