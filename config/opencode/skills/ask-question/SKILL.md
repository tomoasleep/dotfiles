---
name: ask-question
description: ユーザーに質問する必要がある場合、または選択肢から選んでもらいたい場合、確認事項がある場合に使用する
---

ユーザーに質問や確認事項がある場合は、必ず `question` tool を使用してください。

これにより、選択肢付きの質問を提示したり、複数の質問をまとめて行うことができます。

## 使用例

```typescript
question({
  questions: [{
    question: "どのオプションを選択しますか？",
    header: "選択",
    options: [
      { label: "オプションA", description: "説明" }
    ]
  }]
})
```

## 参考

- [question tool ドキュメント](https://opencode.ai/docs/tools/#question)
