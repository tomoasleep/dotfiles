---
name: exec-plan
description: 決まった Plan を agent に委託しながら実施します
---

この Plan を実施してください。

1. 小さなタスクに分解して、 TODO 化してください
2. TOOD のそれぞれを general subagent に委託してください
3. 完了したら、計画の要件にあっているかを検証してください
  - general subagent に検証と、要件不適合な場合のアクションプランを作らせてください。
  - 要件を満たしていなければ、アクションプランの実施を general agent に委託し、検証を最初からやり直します。
