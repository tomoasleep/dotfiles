# Review Template

Use this template for self-review or subagent review.

## Review Request

```markdown
# Hypothesis Review Request

## Workspace
`~/.hypos/YYYY/MM/DD/<short-slug>/`

## Question
[Question]

## Issue Tree
[Major categories]

## Hypotheses
[Hypothesis list]

## Validation Plan
[Validation criteria and priorities]

## Evidence Matrix
[Supporting, contradicting, and missing evidence]

## Provisional Conclusion
[Current leading hypothesis and confidence]

Please review:
1. Are any data points inaccurate or unsupported?
2. Is the evidence sufficient for the claimed confidence?
3. Are there logical jumps between evidence and hypotheses?
4. Are the hypotheses MECE enough for this problem?
5. Are there missing plausible hypotheses?
6. Should any hypotheses be split, merged, or reframed?
7. Were validation criteria defined before evaluating evidence?
8. Did the analysis prioritize the right killer hypotheses?
9. What additional data would most change the conclusion?
```

## Review Output

```markdown
# Review Findings

| Severity | Finding | Affected file | Affected hypothesis | Required action |
| --- | --- | --- | --- | --- |

## Summary

## Missing Hypotheses

## Logic Gaps

## Evidence Quality Issues

## Recommended Next Evidence
```

Severity should be one of:
- High: must resolve before final conclusion
- Medium: should resolve or explicitly acknowledge
- Low: optional improvement
