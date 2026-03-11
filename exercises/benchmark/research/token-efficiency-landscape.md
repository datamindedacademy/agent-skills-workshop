# Token Efficiency & Context Engineering — Research

## Token Tracking & Cost Monitoring

### LiteLLM
Unified LLM proxy that sits between your app and 100+ providers. Auto-tracks tokens, cost per API key/user/team with daily breakdowns. Budget enforcement with automatic caps. Dashboard UI for cost debugging.

- Returns prompt_tokens, completion_tokens, total_tokens, and USD cost on every request
- Spend Report API with date range filtering and grouping
- Fully supports Anthropic models with automatic pricing
- Overkill for a workshop, excellent for production

**Links:**
- https://docs.litellm.ai/docs/proxy/cost_tracking
- https://docs.litellm.ai/docs/completion/token_usage

### Tokenator
Minimal Python library — 3 lines of code to instrument any Anthropic/OpenAI call. Logs tokens and cost. Supports OpenAI, Anthropic, Google, and OpenAI-compatible APIs.

**Links:**
- https://github.com/ujjwalm29/tokenator

### tokencost
Single function: give it a model name + token counts, get USD cost back. Even simpler than Tokenator.

**Links:**
- https://github.com/AgentOps-AI/tokencost

### ccusage
CLI tool that parses Claude Code's local JSONL session logs (~/.claude/projects/) and outputs cost/token breakdowns per day/month/session. Tracks cache creation and cache read tokens separately. Exports JSON.

**Links:**
- https://github.com/ryoppippi/ccusage
- https://ccusage.com/

### TokenX
Single decorator for cost/latency tracking. Lightweight, easy to extend.

**Links:**
- https://medium.com/@devalshah1619/track-llm-costs-latency-with-just-one-decorator-meet-tokenx-161fe2249482

---

## Observability Platforms (with A/B Testing)

### Langfuse
Open-source, self-hostable (MIT license). 19k+ GitHub stars. Built-in prompt A/B testing: label prompt versions, randomly alternate, automatically track latency/tokens/cost/quality. Visual comparison UI. Can run locally via Docker.

**Links:**
- https://langfuse.com/docs/prompt-management/features/a-b-testing
- https://langfuse.com/docs/observability/features/token-and-cost-tracking
- https://langfuse.com/docs/observability/overview

### Helicone
Low-latency proxy (50-80ms overhead). Distributed architecture (Cloudflare Workers, ClickHouse, Kafka). 2B+ LLM interactions processed. Strong caching support.

**Links:**
- https://www.helicone.ai/blog/the-complete-guide-to-LLM-observability-platforms

### Portkey
Most feature-rich AI gateway. Semantic caching, 50+ guardrails, prompt versioning, observability, FinOps dashboard. Supports 1,600+ LLMs.

**Links:**
- https://www.firecrawl.dev/blog/best-llm-observability-tools

### Braintrust
Evaluation-focused SaaS. Real-time and batch evaluation with LLM-as-judge metrics and deterministic checks. Matrix testing (prompt x model x test case).

**Links:**
- https://www.braintrust.dev/articles/ab-testing-llm-prompts

---

## Prompt Compression & Optimization

### LLMLingua (Microsoft Research)
Uses a small model (GPT-2-small or LLaMA-7B) to identify and remove non-essential tokens. Up to 20x compression with only ~1.5% quality drop.

- **LLMLingua-2**: 3-6x faster, better on out-of-domain data, trained via GPT-4 distillation
- **LongLLMLingua**: Addresses "lost in the middle" problem. Improves RAG quality by 21.4% using 1/4 of tokens

**Links:**
- https://llmlingua.com/
- https://github.com/microsoft/LLMLingua

### General techniques
- Semantic summarization: condense repetitive content while retaining meaning
- Structured prompting: JSON/bullet points reduce token count vs prose
- Smart truncation and prioritization of context window contents

**Links:**
- https://redis.io/blog/llm-token-optimization-speed-up-apps/

---

## Claude-Native Capabilities

### Built-in commands
- `/cost` — session cost, duration, code changes count
- `/context` — token breakdown by category (system prompt, MCP servers, conversation history)
- Status line can show real-time context window usage %

### Token Counting API
Free endpoint (`/v1/messages/count_tokens`) estimates input tokens before sending. Supports system prompts, tools, images, PDFs. Estimates may vary slightly from actual usage.

**Links:**
- https://platform.claude.com/docs/en/build-with-claude/token-counting

### Prompt Caching
Cache writes cost 25% of base input price, reads cost 10%. Up to 90% cost reduction and 85% latency reduction for repeated content. Automatically reads longest previously cached prefix.

**Links:**
- https://claude.com/blog/prompt-caching
- https://claude.com/blog/token-saving-updates

### Usage & Cost API
Tracks prompt/completion/total tokens, web search costs, code execution costs. Workspace/description grouping.

**Links:**
- https://platform.claude.com/docs/en/build-with-claude/usage-cost-api

### Claude Code Analytics API
Workspace-level usage tracking. Token usage broken down by model, with tool usage metrics.

**Links:**
- https://docs.anthropic.com/en/api/claude-code-analytics-api

---

## Benchmarks & Evaluation

### SWE-bench
500 human-validated real-world GitHub issues. Measures pass rate on code fixes. Does not track token efficiency directly.

**Links:**
- https://www.swebench.com/

### Aider Benchmarks
225 Exercism problems across 6 languages. Two-attempt evaluation. Tracks pass rate, edit format compliance, and total cost per problem.

**Links:**
- https://aider.chat/docs/benchmarks.html

### Context-Bench (Letta)
Specifically benchmarks "agentic context engineering" tasks — chaining file operations, tracing entity relationships, managing multi-step retrieval. Claude Sonnet 4.5 scores 74.0%.

**Links:**
- https://www.letta.com/blog/context-bench

### ACE Framework (Agentic Context Engineering)
Academic framework. Optimizes contexts offline (system prompt design) and online (dynamic memory adaptation). Shows +10.6% improvement on agent tasks with 58.6% context memory reuse vs 0% for naive RAG.

**Links:**
- https://arxiv.org/html/2510.04618v1

### Promptfoo
Declarative YAML config for multi-provider prompt testing. Define test cases, run variants, get comparison matrix. Supports regression testing and CI/CD integration.

**Links:**
- https://www.promptfoo.dev/docs/intro/
- https://www.promptfoo.dev/docs/category/guides/

---

## Quality Measurement

### LLM-as-Judge
Strong LLM judges (GPT-4, Claude) achieve 80-90% agreement with human evaluators. Three modes:
- Single output scoring against a rubric
- Reference-based scoring against a gold standard
- Pairwise comparison (which output is better?) — most reliable

**Links:**
- https://www.confident-ai.com/blog/why-llm-as-a-judge-is-the-best-llm-evaluation-method
- https://arxiv.org/html/2501.00274v1

### Promptfoo LLM Rubric
Define custom rubrics for model-graded evaluation. Supports few-shot examples per score level.

**Links:**
- https://www.promptfoo.dev/docs/configuration/expected-outputs/model-graded/llm-rubric/

---

## Context Engineering Guides

- https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- https://promptingguide.ai/guides/context-engineering-guide
- https://www.turingcollege.com/blog/context-engineering-guide

---

## A/B Testing Methodology

Key principles:
- Set temperature=0 for reproducibility
- Run each condition 3-5 times, report mean +/- std dev
- 400-600 test cases needed to detect 5% improvement with 95% confidence
- Always include confidence intervals, not just point estimates

**Links:**
- https://www.braintrust.dev/articles/ab-testing-llm-prompts
- https://langfuse.com/docs/prompt-management/features/a-b-testing
- https://dev.to/kuldeep_paul/ab-testing-prompts-a-complete-guide-to-optimizing-llm-performance-1442
- https://arxiv.org/html/2601.22025
