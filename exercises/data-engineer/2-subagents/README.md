# Stage 2: Add subagents, `failure-triage` (60 min)

Diagnosing several failures at once is independent, log-heavy work: one
subagent per failure, each reading its own logs, is when subagents earn their
keep.

1. Open `.claude/skills/failure-triage/SKILL.md`.
2. Work through the TODOs: find what's failing, **dispatch one subagent per
   failure in parallel** (each returns a compact verdict), then synthesize one
   incident summary ranked by severity.
3. Run `/failure-triage` (or ask "what's broken?").

> **Tip:** editing the skill while a `claude` session is open? Run
> `/reload-skills` in that session to pick up your changes.

One failure: diagnose it inline (Stage 1). Many: fan out, then synthesize. The
win is context: each subagent absorbs its own log noise and returns a verdict,
instead of every log flooding one window.

## Pick your mode

Guided, Challenge, or Expert — the Sorting Hat already set your skeletons up for
the mode you picked. See **[Difficulty modes](../../MODES.md)** for what that
changed and how to switch.

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

## Challenge: cheapest passing triage

Measure on **clean context** — `/clear` first. Not `/compact`: compaction costs
tokens itself and leaves a summary behind, so the number stops being comparable.

```
/clear
/cost              # baseline
/failure-triage
/cost              # delta = what one run of your skill costs
```

Now make that delta smaller without failing the checklist. What moves it:

- a tight brief per subagent — vague instructions buy log-trawling
- what each subagent **returns**: a verdict, not the logs behind it
- a smaller model for the *subagents* — cheap readers, capable synthesizer
- an exact output spec — no re-drafting the incident summary

Lowest output-token run that still passes the "Done when" checks wins.
