---
description: セッション開始時にObsidian Vaultからルール・好み・ミス記録を読み取る。セッション開始時、または「Obsidianを読んで」「前回の続きで」と言われた時にロード。
---

# Obsidian Memory Read

セッション開始時にObsidian Vaultから過去の学習・好み・ミス記録を読み込み、現在のセッションに活かす。

## トリガー

- セッション開始時（自動的に実行）
- ユーザーが「Obsidianを読んで」「前回の続きで」「記憶を読んで」などと言った時

## 手順

### Step 1: ミス記録の読み込み

`Mistakes/` 配下の最近更新ファイル（最新5件）を読み込む。

```bash
obsidian search query="mistake" limit=5
```

ヒットしたファイルの内容を読む。

### Step 2: 好みルールの読み込み

`Preferences/` 配下の全ファイルを読み込む。

```bash
obsidian search query="preference OR personal OR coding-style" limit=20
```

### Step 3: 関連知識の検索

ユーザーの質問に関連するキーワードでVaultを検索。

- 検索語: ユーザー発話からキーワード抽出 + repo名 + エラー文（あれば）
- 検索結果は最大5件に制限

```bash
obsidian search query="<keyword>" limit=5
```

### Step 4: 読み込んだ内容の適用

- 矛盾するノートがある場合: 日付が新しい方を優先
- 内部コンテキストとして使用
- 読み込んだ内容をユーザーに要約して報告しない（内部処理のみ）

## 注意事項

- 読み込みはサイレントに実行（ユーザーに報告しない）
- ユーザーが明示的に「何を読んだか」を尋ねた場合のみ報告
- Vaultが空の場合はスキップ
