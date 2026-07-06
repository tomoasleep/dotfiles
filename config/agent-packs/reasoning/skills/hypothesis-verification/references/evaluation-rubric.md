# Evaluation Rubric

Use this rubric when evaluating outputs from the `hypothesis-verification` skill.

## Required Qualities

An effective output should:
- Define the question before answering
- Create a workspace under `~/.hypos/YYYY/MM/DD/<short-slug>/` for non-trivial investigations
- Build an issue tree or equivalent hypothesis space map
- Generate multiple comparable hypotheses
- Include predictions and disconfirming signals before evaluating evidence
- Define validation criteria before collecting or interpreting evidence
- Prioritize killer hypotheses by cost and information value
- Separate evidence from interpretation
- Track supporting, contradicting, and missing evidence
- Evaluate evidence reliability
- Check for logical gaps and MECE issues
- Include review findings or explain why review was unnecessary
- Record rejected hypotheses and reasons when iterating
- Present calibrated confidence
- Include remaining uncertainty and what would change the conclusion

## Common Failures

Treat these as failures:
- One favored hypothesis appears immediately without alternatives
- Hypotheses are not falsifiable
- Supporting evidence is collected but contradicting evidence is absent
- Speculation is presented as evidence
- Validation criteria appear only after the conclusion
- Confidence is high while key evidence is missing
- The conclusion cannot be traced back to evidence
- The output is verbose but does not reduce uncertainty

## Suggested Eval Prompts

Should trigger:
- `最近 PR のレビューが遅くなっている気がする。原因を決めつけずに調べる観点を整理してほしい。`
- `CI の flaky test が増えた。考えられる原因を洗い出して、どれが一番ありそうか判断したい。過程も残したい。`
- `新機能の利用率が低い理由を分析したい。ログやユーザー行動から仮説を立てて検証する流れを作って。`
- `この障害の原因が DB なのかアプリなのか外部 API なのか切り分けたい。`
- `このプロダクト施策を続けるべきか判断したい。考えられる説明と必要なデータを整理して。`

Should not trigger:
- `この Ruby のメソッドをリファクタリングして。`
- `README の文章を自然な日本語に直して。`
- `このエラーを直して。原因はすでに分かっていて、設定値が間違っている。`
- `この GitHub Issue を実装するための作業計画を作って。`
