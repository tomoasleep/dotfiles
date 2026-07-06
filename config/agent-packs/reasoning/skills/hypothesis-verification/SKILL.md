---
name: hypothesis-verification
description: Use when the user asks to reason through an uncertain question, compare competing explanations, investigate causes, choose the best hypothesis, or avoid jumping to conclusions. This skill structures question framing, issue trees, broad hypothesis generation, validation criteria, evidence gathering, disconfirmation, MECE review, logical-gap review, and iterative refinement before presenting a calibrated conclusion. Use especially for ambiguous debugging, product/strategy analysis, incident analysis, research synthesis, root-cause analysis, and decisions where multiple plausible explanations exist.
---

# Hypothesis Verification

## Core Principle

Do not choose a conclusion before comparing multiple falsifiable hypotheses against supporting and contradicting evidence.

The goal is not to sound decisive. The goal is to make the uncertainty legible, reduce it with evidence, and state a calibrated conclusion.

## When To Use

Use this skill when the task involves an uncertain explanation, cause, decision, or diagnosis.

Examples:
- Root-cause analysis where multiple causes are plausible
- Product or strategy analysis where user behavior has several explanations
- Incident analysis where infrastructure, application, and external dependencies may all contribute
- Research synthesis where sources conflict or are incomplete
- Decisions where a wrong conclusion would cause wasted work

For a simple one-step known fix, do not use this skill. For a complex technical bug, use this skill together with a systematic debugging workflow.

## Workspace

For non-trivial investigations, create a workspace under `~/.hypos/YYYY/MM/DD/<short-slug>/` and persist intermediate artifacts there.

Create a workspace when any of these are true:
- Three or more hypotheses are plausible
- Evidence collection is needed
- The conclusion affects a meaningful decision
- Review or iteration is needed
- The user asks to preserve the process

Use `references/workspace-template.md` for the standard file layout and templates.

For small questions, you may keep the artifacts in the response, but still follow the same structure mentally.

If the user specifies a different workspace root, use that root while preserving the same `YYYY/MM/DD/<short-slug>/` layout. Treat `~/.hypos` as the default, not a hard requirement.

## Workflow

### 1. Define The Question

Write the question in one sentence before generating hypotheses.

Capture:
- Question
- Scope
- Out of scope
- Decision this supports
- Assumptions or user questions

If the question is ambiguous and the ambiguity affects the result, ask the user one concise question. If you can proceed with an explicit assumption, state it and continue.

### 2. Build An Issue Tree

Break the question into major categories before listing hypotheses.

This reduces missing possibilities and prevents mixing different abstraction levels.

Example categories for flaky CI:
- CI environment
- External dependencies
- Test implementation
- Application changes
- Time, data, or concurrency effects

### 3. Generate Broad Hypotheses

Generate enough hypotheses before favoring one.

Default target:
- At least 5 hypotheses for a meaningful investigation
- 8-12 hypotheses for complex or high-impact questions

Each hypothesis must include:
- Category
- Because
- Prediction
- Disconfirming signal
- Prior plausibility

The `Prediction` and `Disconfirming signal` must be written before evidence is evaluated. This prevents retrofitting evidence to a favored answer.

### 4. Normalize The Hypothesis Set

Before collecting data, review the hypothesis set.

Check:
- Are the hypotheses at comparable abstraction levels?
- Are causes, symptoms, and remedies mixed together?
- Are any hypotheses overlapping and better merged?
- Are any hypotheses too broad and better split?
- Are there missing major categories?
- Are non-mutually-exclusive hypotheses being forced into a false competition?

Update the issue tree and hypothesis list before moving on.

### 5. Plan Validation Criteria

Do not gather evidence opportunistically. First define what would support, weaken, or revise each hypothesis.

For each hypothesis, define:
- Supporting data to seek
- Disconfirming data to seek
- Validation criterion
- Source
- Cost
- Information value
- Priority

Validation criteria should be decided before seeing the data. Do not move the goalposts to preserve a preferred hypothesis.

### 6. Choose Killer Hypotheses

Do not investigate every hypothesis with equal depth.

Prioritize hypotheses that:
- Would significantly change the decision if true
- Can be tested with low cost
- Distinguish between multiple alternatives
- Directly affect the next action

Record why the chosen killer hypotheses are tested first.

### 7. Gather Supporting And Contradicting Evidence

Separate evidence from interpretation.

For each evidence item, record:
- ID
- Evidence
- Source
- Evidence type
- Reliability
- Which hypotheses it supports
- Which hypotheses it contradicts
- Notes or caveats

Classify evidence quality:
- Direct observation
- Reproducible experiment
- Primary source document or log
- Aggregated metric
- Secondary report
- Inference or speculation

Never present speculation as evidence.

If the task is explicitly a hypothetical investigation setup and real data is unavailable, do not fabricate real evidence. You may create modeled or hypothetical evidence only when it is clearly labeled as such, and the final report must state that confidence is limited because real observations were not collected.

### 8. Build The Evidence Matrix

For each hypothesis, summarize:
- Supporting evidence
- Contradicting evidence
- Missing evidence
- Status
- Confidence

Use `Low`, `Medium`, or `High` confidence by default. Avoid precise percentages unless the evidence warrants them.

Missing evidence is a first-class result. It should reduce confidence or trigger further investigation.

### 9. Check Logic Gaps

Before reviewing or reporting, inspect the reasoning.

Ask:
- Does the data actually support this hypothesis?
- Could another hypothesis explain the same data equally well?
- Is correlation being treated as causation?
- Is the sample too small or biased?
- Is absence of evidence being treated as evidence of absence?
- Is contradicting evidence acknowledged fairly?
- Does the conclusion overstate the evidence?
- Were validation criteria changed after seeing evidence?

### 10. Review

For important investigations, perform a self-review or ask a subagent to review the workspace.

Use self-review for lightweight or hypothetical investigations. Use a separate subagent review when the conclusion affects a meaningful decision, the evidence is large, or the analysis has multiple iterations.

Use `references/review-template.md` for the review request and output format.

The review must check:
- Data accuracy
- Evidence sufficiency
- Logical jumps
- MECE quality
- Missing hypotheses
- Split or merge candidates
- Validation criteria quality
- Killer hypothesis priority
- Most valuable next evidence

### 11. Iterate

If review finds high-severity issues, do not finalize.

Iterate:
1. Read review findings
2. Add, split, merge, or reject hypotheses
3. Update validation criteria without moving goalposts
4. Gather additional evidence
5. Update the evidence matrix
6. Record the iteration history
7. Review again if needed

Rejected hypotheses must remain recorded with rejection reasons.

Stop iterating when:
- Major hypotheses have enough supporting and contradicting evidence
- Remaining uncertainty does not affect the decision
- Additional evidence has low information value relative to cost
- A user decision or missing premise is blocking further progress

### 12. Report A Calibrated Conclusion

The final answer should say which hypothesis is most supported, not pretend certainty.

Use this structure:

```markdown
# Hypothesis Verification Report

## Question

## Short Answer
現時点で最も支持される仮説は Hn です。理由は ... です。

## Confidence
Low / Medium / High

## Leading Hypothesis

## Why The Leading Hypothesis Wins

## Why Alternatives Are Weaker

## Evidence Matrix Summary

## Remaining Uncertainty

## What Would Change This Conclusion

## Recommended Next Action

## Workspace
`~/.hypos/YYYY/MM/DD/<short-slug>/`
```

Always include `Remaining Uncertainty` and `What Would Change This Conclusion` for non-trivial investigations.

## Failure Modes

Avoid these failures:
- Starting with a single favored hypothesis unless the user asked only for validation
- Treating absence of evidence as evidence of absence
- Presenting speculation as evidence
- Ignoring contradicting evidence
- Comparing hypotheses at different abstraction levels without restructuring them
- Merging hypotheses that need different evidence
- Stating high confidence when material evidence is missing
- Changing validation criteria after seeing evidence to preserve a hypothesis
- Deleting rejected hypotheses without recording why they were rejected
- Skipping review when the conclusion affects an important decision

## References

- `references/workspace-template.md`: workspace layout and artifact templates
- `references/review-template.md`: self-review and subagent review prompt
- `references/evaluation-rubric.md`: criteria for evaluating this skill's output
