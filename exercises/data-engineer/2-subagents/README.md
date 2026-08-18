# Stage 2: Add subagents, `failure-triage` (60 min)

Diagnosing several failures at once is independent, log-heavy work: one
subagent per failure, each reading its own logs, is when subagents earn their
keep.

1. Open `.claude/skills/failure-triage/SKILL.md`.
2. Work through the TODOs: find what's failing, **dispatch one subagent per
   failure in parallel** (each returns a compact verdict), then synthesize one
   incident summary ranked by severity.
3. Run `/failure-triage` (or ask "what's broken?").

One failure: diagnose it inline (Stage 1). Many: fan out, then synthesize. The
win is context: each subagent absorbs its own log noise and returns a verdict,
instead of every log flooding one window.

## Done when

Run the checker from this folder:

```bash
bash tests/test-failure-triage.sh
```

It verifies the structure and then hands you the behavioural test. You're done
when all three hold:

- [ ] "what's broken?" finds the failing DAG(s) and dispatches one subagent per
      failure, **visibly in parallel**.
- [ ] The incident summary ranks failures by severity — root cause, evidence,
      and suggested fix per DAG — and calls out any shared cause.
- [ ] Your conversation holds **verdicts, not raw logs**: the subagents kept
      the log noise to themselves.
