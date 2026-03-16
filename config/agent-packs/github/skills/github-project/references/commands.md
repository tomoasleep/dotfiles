# `gh project` Commands Reference

全サブコマンドの詳細なリファレンス。

## プロジェクト操作

### `gh project list`

プロジェクトの一覧を表示。

```bash
gh project list [flags]
```

| オプション | 説明 |
|-----------|------|
| `--closed` | クローズ済みも含む |
| `--format json` | JSON形式 |
| `--jq <expr>` | jq フィルタ |
| `--limit <n>` | 件数上限（デフォルト30） |
| `--owner <login>` | オーナー（`@me`で現在のユーザー） |
| `-t, --template` | Go テンプレート |
| `-w, --web` | ブラウザで開く |

例:
```bash
gh project list --owner @me
gh project list --owner github --closed --format json
gh project list --owner @me --limit 100
```

### `gh project view`

プロジェクトの詳細を表示。

```bash
gh project view [<number>] [flags]
```

| オプション | 説明 |
|-----------|------|
| `--format json` | JSON形式 |
| `--jq <expr>` | jq フィルタ |
| `--owner <login>` | オーナー（`@me`で現在のユーザー） |
| `-t, --template` | Go テンプレート |
| `-w, --web` | ブラウザで開く |

例:
```bash
gh project view 1 --owner @me
gh project view 5 --owner github --web
gh project view 1 --owner @me --format json
```

### `gh project create`

新しいプロジェクトを作成。

```bash
gh project create [flags]
```

| オプション | 説明 |
|-----------|------|
| `--owner <login>` | オーナー（必須） |
| `--title <string>` | プロジェクトタイトル（必須） |
| `--format json` | JSON形式 |
| `--jq <expr>` | jq フィルタ |
| `-t, --template` | Go テンプレート |

例:
```bash
gh project create --owner @me --title "Roadmap 2024"
gh project create --owner github --title "Team Backlog" --format json
```

### `gh project copy`

プロジェクトをコピー。

```bash
gh project copy [<number>] [flags]
```

| オプション | 説明 |
|-----------|------|
| `--new-title <string>` | 新しいタイトル |
| `--owner <login>` | オーナー |
| `--format json` | JSON形式 |
| `--jq <expr>` | jq フィルタ |
| `-t, --template` | Go テンプレート |

例:
```bash
gh project copy 1 --owner @me --new-title "Q1 Backlog"
```

### `gh project edit`

プロジェクトを編集。

```bash
gh project edit [<number>] [flags]
```

| オプション | 説明 |
|-----------|------|
| `--owner <login>` | オーナー |
| `--title <string>` | 新しいタイトル |
| `--readme <string>` | READMEの内容 |
| `--short-description <string>` | 短い説明 |
| `--format json` | JSON形式 |
| `--jq <expr>` | jq フィルタ |
| `-t, --template` | Go テンプレート |

例:
```bash
gh project edit 1 --owner @me --title "Updated Title"
```

### `gh project close`

プロジェクトをクローズ。

```bash
gh project close [<number>] [flags]
```

| オプション | 説明 |
|-----------|------|
| `--owner <login>` | オーナー |
| `--format json` | JSON形式 |
| `--jq <expr>` | jq フィルタ |
| `-t, --template` | Go テンプレート |

例:
```bash
gh project close 1 --owner @me
```

### `gh project delete`

プロジェクトを削除。

```bash
gh project delete [<number>] [flags]
```

| オプション | 説明 |
|-----------|------|
| `--owner <login>` | オーナー |
| `--yes` | 確認をスキップ |

例:
```bash
gh project delete 1 --owner @me --yes
```

### `gh project link`

リポジトリとプロジェクトをリンク。

```bash
gh project link [<number>] [flags]
```

| オプション | 説明 |
|-----------|------|
| `--owner <login>` | プロジェクトのオーナー |
| `--repo <repo>` |リポジトリ（owner/repo形式） |

例:
```bash
gh project link 1 --owner @me --repo myorg/myrepo
```

### `gh project unlink`

リポジトリとのリンクを解除。

```bash
gh project unlink [<number>] [flags]
```

例:
```bash
gh project unlink 1 --owner @me --repo myorg/myrepo
```

### `gh project mark-template`

プロジェクトをテンプレートとしてマーク。

```bash
gh project mark-template [<number>] [flags]
```

例:
```bash
gh project mark-template 1 --owner @me
```

---

## アイテム操作

### `gh project item-list`

プロジェクト内のアイテム一覧を表示。

```bash
gh project item-list [<number>] [flags]
```

| オプション | 説明 |
|-----------|------|
| `--format json` | JSON形式 |
| `--jq <expr>` | jq フィルタ |
| `--limit <n>` | 件数上限（デフォルト30） |
| `--owner <login>` | オーナー |
| `--query <string>` |フィルタ構文で検索 |
| `-t, --template` | Go テンプレート |

フィルタ構文（github.comおよびGHES 3.20+でサポート）:
```
assignee:octocat -status:Done
label:bug is:issue is:open
```

例:
```bash
gh project item-list 1 --owner @me
gh project item-list 1 --owner github --query "status:Todo"
gh project item-list 1 --owner @me --format json --jq '.[] | .title'
```

### `gh project item-add`

Issue または PR をプロジェクトに追加。

```bash
gh project item-add [<number>] [flags]
```

| オプション | 説明 |
|-----------|------|
| `--owner <login>` | オーナー |
| `--url <string>` | Issue/PR のURL（必須） |
| `--format json` | JSON形式 |
| `--jq <expr>` | jq フィルタ |
| `-t, --template` | Go テンプレート |

例:
```bash
gh project item-add 1 --owner @me --url https://github.com/owner/repo/issues/123
gh project item-add 5 --owner github --url https://github.com/github/cli/pull/456
```

### `gh project item-create`

ドラフト Issue をプロジェクト内に作成。

```bash
gh project item-create [<number>] [flags]
```

| オプション | 説明 |
|-----------|------|
| `--owner <login>` | オーナー |
| `--title <string>` | タイトル（必須） |
| `--body <string>` | 本文 |
| `--format json` | JSON形式 |
| `--jq <expr>` | jq フィルタ |
| `-t, --template` | Go テンプレート |

例:
```bash
gh project item-create 1 --owner @me --title "Draft Task" --body "Description here"
```

### `gh project item-edit`

アイテムまたはフィールド値を編集。

```bash
gh project item-edit [flags]
```

| オプション | 説明 |
|-----------|------|
| `--id <string>` | アイテムID（必須） |
| `--project-id <string>` | プロジェクトID（フィールド編集時に必須） |
| `--field-id <string>` | フィールドID |
| `--text <string>` | テキスト値 |
| `--number <float>` | 数値 |
| `--date <string>` | 日付（YYYY-MM-DD） |
| `--single-select-option-id <string>` | 単一選択オプションID |
| `--iteration-id <string>` | イテレーションID |
| `--clear` | フィールド値をクリア |
| `--title <string>` | ドラフトIssueのタイトル |
| `--body <string>` | ドラフトIssueの本文 |
| `--format json` | JSON形式 |
| `--jq <expr>` | jq フィルタ |
| `-t, --template` | Go テンプレート |

例:
```bash
gh project item-edit --id PVTI_... --title "New Title" --body "New body"
gh project item-edit --id PVTI_... --project-id PVT_... --field-id PVTF_... --text "New value"
gh project item-edit --id PVTI_... --project-id PVT_... --field-id PVTF_... --clear
```

### `gh project item-archive`

アイテムをアーカイブ。

```bash
gh project item-archive [flags]
```

| オプション | 説明 |
|-----------|------|
| `--id <string>` | アイテムID（必須） |
| `--project-id <string>` | プロジェクトID（必須） |
| `--format json` | JSON形式 |
| `--jq <expr>` | jq フィルタ |
| `-t, --template` | Go テンプレート |

例:
```bash
gh project item-archive --id PVTI_... --project-id PVT_...
```

### `gh project item-delete`

アイテムを削除。

```bash
gh project item-delete [flags]
```

| オプション | 説明 |
|-----------|------|
| `--id <string>` | アイテムID（必須） |
| `--project-id <string>` | プロジェクトID（必須） |
| `--format json` | JSON形式 |
| `--jq <expr>` | jq フィルタ |
| `-t, --template` | Go テンプレート |

例:
```bash
gh project item-delete --id PVTI_... --project-id PVT_...
```

---

## フィールド操作

### `gh project field-list`

プロジェクトのフィールド一覧を表示。

```bash
gh project field-list [<number>] [flags]
```

| オプション | 説明 |
|-----------|------|
| `--format json` | JSON形式 |
| `--jq <expr>` | jq フィルタ |
| `--limit <n>` | 件数上限（デフォルト30） |
| `--owner <login>` | オーナー |
| `-t, --template` | Go テンプレート |

例:
```bash
gh project field-list 1 --owner @me
gh project field-list 1 --owner github --format json
```

### `gh project field-create`

新しいフィールドを作成。

```bash
gh project field-create [<number>] [flags]
```

| オプション | 説明 |
|-----------|------|
| `--owner <login>` | オーナー |
| `--name <string>` | フィールド名（必須） |
| `--single-select-option <strings>` | 単一選択オプション（カンマ区切り） |
| `--iteration-start-date <string>` | イテレーション開始日（YYYY-MM-DD） |
| `--iteration-duration <int>` | イテレーション期間（日数） |
| `--data-type <string>` | データ型（TEXT, NUMBER, DATE, SINGLE_SELECT, ITERATION） |
| `--format json` | JSON形式 |
| `--jq <expr>` | jq フィルタ |
| `-t, --template` | Go テンプレート |

例:
```bash
gh project field-create 1 --owner @me --name "Priority" --single-select-option "High,Medium,Low"
gh project field-create 1 --owner @me --name "Sprint" --data-type ITERATION --iteration-start-date 2024-01-01 --iteration-duration 14
```

### `gh project field-delete`

フィールドを削除。

```bash
gh project field-delete [flags]
```

| オプション | 説明 |
|-----------|------|
| `--id <string>` | フィールドID（必須） |
| `--project-id <string>` | プロジェクトID（必須） |
| `--format json` | JSON形式 |
| `--jq <expr>` | jq フィルタ |
| `-t, --template` | Go テンプレート |

例:
```bash
gh project field-delete --id PVTF_... --project-id PVT_...
```

---

## ID の取得方法

### プロジェクトID

```bash
gh project view 1 --owner @me --format json --jq '.id'
```

### アイテムID

```bash
gh project item-list 1 --owner @me --format json --jq '.[] | select(.title=="My Item") | .id'
```

### フィールドID

```bash
gh project field-list 1 --owner @me --format json --jq '.[] | select(.name=="Status") | .id'
```

### 単一選択オプションID

```bash
gh project field-list 1 --owner @me --format json --jq '.[] | select(.name=="Status") | .options[] | select(.name=="Done") | .id'
```