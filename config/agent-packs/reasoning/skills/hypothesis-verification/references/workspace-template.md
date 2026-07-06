# Workspace Template

Use this layout for non-trivial hypothesis verification work:

```text
~/.hypos/YYYY/MM/DD/<short-slug>/
├── index.md
├── 00-question.md
├── 01-issue-tree.md
├── 02-hypotheses.md
├── 03-validation-plan.md
├── 04-evidence-ledger.md
├── 05-evidence-matrix.md
├── 06-review.md
├── 07-iterations.md
└── final-report.md
```

## `index.md`

```markdown
# [Investigation Title]

## Question

## Status
in_progress

## Leading Hypothesis
None yet

## Confidence
None

## Workspace Files
- `00-question.md`
- `01-issue-tree.md`
- `02-hypotheses.md`
- `03-validation-plan.md`
- `04-evidence-ledger.md`
- `05-evidence-matrix.md`
- `06-review.md`
- `07-iterations.md`
- `final-report.md`
```

## `00-question.md`

```markdown
# Question

## Question

## Scope

## Out Of Scope

## Decision This Supports

## Assumptions

## Questions For The User
```

## `01-issue-tree.md`

```markdown
# Issue Tree

## Root Question

## Categories
1. [Category]
2. [Category]
3. [Category]

## MECE Notes
- Missing categories considered:
- Overlaps to resolve:
```

## `02-hypotheses.md`

```markdown
# Hypotheses

## H1: [Hypothesis]

- Category:
- Because:
- Prediction:
- Disconfirming signal:
- Prior plausibility: Low / Medium / High
- Status: untested / partially supported / weakened / rejected / leading

## Split / Merge Notes
```

## `03-validation-plan.md`

```markdown
# Validation Plan

| Hypothesis | Supporting data to seek | Disconfirming data to seek | Validation criterion | Source | Cost | Info value | Priority |
| --- | --- | --- | --- | --- | --- | --- | --- |

## Killer Hypotheses

1. [Hypothesis]
   - Why first:
   - Distinguishes from:
```

## `04-evidence-ledger.md`

```markdown
# Evidence Ledger

| ID | Evidence | Source | Type | Reliability | Supports | Contradicts | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
```

Evidence type should be one of:
- Direct observation
- Reproducible experiment
- Primary source document or log
- Aggregated metric
- Secondary report
- Inference or speculation

## `05-evidence-matrix.md`

```markdown
# Evidence Matrix

| Hypothesis | Supporting evidence | Contradicting evidence | Missing evidence | Status | Confidence |
| --- | --- | --- | --- | --- | --- |
```

## `06-review.md`

```markdown
# Review

## Review Findings

| Severity | Finding | Affected file | Affected hypothesis | Required action |
| --- | --- | --- | --- | --- |

## Reviewer Summary
```

## `07-iterations.md`

```markdown
# Iterations

## Iteration 1

- Changed:
- Added:
- Split:
- Merged:
- Rejected:
- Reason:
- New leading hypothesis:
- Confidence change:
```

## `final-report.md`

```markdown
# Hypothesis Verification Report

## Question

## Short Answer

## Confidence

## Leading Hypothesis

## Why The Leading Hypothesis Wins

## Why Alternatives Are Weaker

## Evidence Matrix Summary

## Remaining Uncertainty

## What Would Change This Conclusion

## Recommended Next Action

## Workspace
```
