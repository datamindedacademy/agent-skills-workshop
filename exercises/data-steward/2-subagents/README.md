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

With one data product, we fan out over its failing *checks*. In a real org you'd
more often have many data products and fan out one subagent per product, running
this whole skill across each; here we show the same pattern on what we have.
Either way the wrinkle is the same: the subagents draft in parallel but *don't*
write (they share one schema file), and you make the single careful merge at the
end. Fan out the thinking, centralize the change.

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
