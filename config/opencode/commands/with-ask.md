---
name: with-ask
description: Ask つきで行う
---

ユーザーに質問や確認事項がある場合は、必ず `question` tool を使用してください。

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

---
