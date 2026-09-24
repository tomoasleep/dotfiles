---
description: ユーザーの好み・作業スタイルをObsidianのPreferences/に記録する。恒久的な好みまたはリポジトリ固有ルールを記録。
---

# Obsidian Memory Write - Preferences

ユーザーの好みや作業スタイルをObsidian Vaultの `Preferences/` に記録する。

## トリガー

以下の条件を**すべて**満たす時に実行:

- ユーザーから好みの指摘・訂正があった
- 恒久的な好みまたはリポジトリ固有ルールである
- 一時的な指示ではない

**記録しないもの**:
- 一時的な指示（「今回はこうして」など）
- 環境依存の設定
- 一度きりのリクエスト

## 手順

### Step 1: 分類の判断

- **ユーザー個人の恒久的好み**: `Preferences/personal.md` に追記
- **リポジトリ固有のルール**: `Preferences/<repo-name>.md` に追記

`<repo-name>` は `git rev-parse --show-toplevel 2>/dev/null | xargs basename 2>/dev/null` で取得。

### Step 2: ノート追記

既存ファイルに追記（なければ新規作成）。

```bash
obsidian append path="Preferences/personal.md" content="
- YYYY-MM-DD: <ルール/好みの説明>" inline
```

または

```bash
obsidian append path="Preferences/<repo-name>.md" content="
- YYYY-MM-DD: <ルール/好みの説明>" inline
```

### Step 3: 報告

ユーザーに以下のみ報告:
```
Obsidian: Preferences/personal.md に書き込みました
```

## 注意事項

- 追記形式で既存の内容を壊さない
- 内容は簡潔に（1行程度）
- 複数の好みがある場合はまとめて追記
