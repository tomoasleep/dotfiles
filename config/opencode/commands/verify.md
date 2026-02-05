---
name: verify
description: Verify task requirements and lint errors
---

与えられた要件にあっているか、テスト、Linter 違反が無いかを検証してください。検証と修正は subagent に委託します。

1. general subagent に検証と、要件不適合な場合のアクションプランを作らせてください。
  - アクションプランが既存の方針を変更する場合は、事前にユーザーに確認してください
2. 要件を満たしていなければ、アクションプランの実施を general agent に委託し、検証を最初からやり直します。
  - 方針の変更が必要や、既存のコードの大幅な変更が必要な場合は question tool でユーザーに相談してください
  
※ 対応中に相談や質問がある場合は question tool を使ってください。
