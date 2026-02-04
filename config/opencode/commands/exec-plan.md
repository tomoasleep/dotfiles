---
name: exec-plan
description: 決まった Plan を agent に委託しながら実施します
---

この Plan を実施してください。タスクは自身で行わず、subagent に委託しなければなりません。

1. 小さなタスクに分解して、 TODO 化してください
2. TOOD のそれぞれを general subagent に委託してください
3. 完了したら、 general subagent を /verify コマンド付きで呼び出し (例: `/verify (今回の依頼内容)`) 要件に合うように直していきます。
  
※ 対応中に相談や質問がある場合は question tool を使ってください。
