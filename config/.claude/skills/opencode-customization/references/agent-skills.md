# Agent Skills

## 概要

SKILL.md定義を通じて再利用可能な振る舞いを定義します。特定のドメインやタスクのための「オンボーディングガイド」として機能します。

## ファイルの配置

- `.opencode/skills/<name>/SKILL.md` (プロジェクト)
- `~/.config/opencode/skills/<name>/SKILL.md` (グローバル)
- `.claude/skills/<name>/SKILL.md` (Claude互換)

## Frontmatter

```yaml
---
name: skill-name
description: Skillの説明（いつ使用すべきか）
---
```

## 権限の設定

```json
{
  "permission": {
    "skill": {
      "*": "allow",
      "internal-*": "deny"
    }
  }
}
```

## 公式ドキュメントの内容

- 名前の検証ルール（文字数、形式）
- 長さのルール
- ツール説明の認識
- エージェントごとのオーバーライド
- スキルツールの無効化
- トラブルシューティング

## 参照タイミング

以下の場合に公式ドキュメントを確認してください：

- 名前の検証ルールや長さ制限を詳しく知りたい場合
- エージェントごとの権限オーバーライド方法を知りたい場合
- トラブルシューティングが必要な場合

## 公式ドキュメント

https://opencode.ai/docs/skills
