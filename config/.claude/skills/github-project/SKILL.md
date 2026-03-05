---
name: github-project
description: "GitHub Projects (Projects V2) の情報取得・操作を行う。Use when Claude needs to: (1) List/view GitHub Projects, (2) Get items/fields from a project, (3) Add/edit/delete project items, (4) Create/manage project fields"
---

# GitHub Project

`gh project` コマンドを使用して GitHub Projects (Projects V2) を操作するための Skill。

## 認証要件

`project` scope が必要:
```bash
gh auth refresh -s project
```

## プロジェクトURLと引数の関係

GitHub Projects の URL と `gh project` コマンドの引数の対応:

| URL形式 | owner | project number |
|---------|-------|----------------|
| `https://github.com/users/monalisa/projects/1` | `monalisa` | `1` |
| `https://github.com/orgs/github/projects/5` | `github` | `5` |
| `https://github.com/users/me/projects/3` | `@me` | `3` |

```bash
gh project view 1 --owner monalisa
gh project item-list 5 --owner github
gh project field-list 3 --owner @me
```

## 共通オプション

詳細は [common-options.md](references/common-options.md) を参照。

| オプション | 説明 |
|-----------|------|
| `--format json` | JSON形式で出力 |
| `--jq <expr>` | jq式でフィルタリング |
| `--owner <login>` | オーナー指定（`@me`で現在のユーザー） |
| `--limit <n>` | 取得件数（デフォルト30） |
| `-t, --template` | Go テンプレートでフォーマット |
| `-w, --web` | ブラウザで開く |

## Quick Commands

### プロジェクト情報

```bash
gh project list --owner @me
gh project list --owner github --closed
gh project view 1 --owner @me
gh project view 1 --owner github --web
```

### アイテム操作

```bash
gh project item-list 1 --owner @me
gh project item-list 1 --owner @me --query "status:Todo"
gh project item-add 1 --owner @me --url https://github.com/owner/repo/issues/123
gh project item-create 1 --owner @me --title "Draft Issue" --body "Description"
gh project item-edit --id <item-id> --project-id <project-id> --field-id <field-id> --text "value"
gh project item-delete --id <item-id> --project-id <project-id>
```

### フィールド操作

```bash
gh project field-list 1 --owner @me
gh project field-create 1 --owner @me --name "Priority" --single-select-option "High,Medium,Low"
```

### プロジェクト管理

```bash
gh project create --owner @me --title "New Project"
gh project copy 1 --owner @me --new-title "Copied Project"
gh project edit 1 --owner @me --title "Updated Title"
gh project close 1 --owner @me
```

## Common Workflows

### 1. プロジェクトのアイテムを確認

```bash
gh project item-list 1 --owner @me --format json --jq '.[] | {title: .title, status: .status}'
```

### 2. Issue をプロジェクトに追加

```bash
gh project item-add 1 --owner github --url https://github.com/github/repo/issues/456
```

### 3. アイテムのフィールド値を更新

まずフィールドIDを取得:
```bash
gh project field-list 1 --owner @me --format json --jq '.[] | select(.name=="Status") | .id'
```

次にアイテムIDを取得:
```bash
gh project item-list 1 --owner @me --format json --jq '.[] | select(.title=="My Issue") | .id'
```

最後に更新:
```bash
gh project item-edit --id <item-id> --project-id <project-id> --field-id <field-id> --single-select-option-id <option-id>
```

### 4. フィルタを使ってアイテム検索

```bash
gh project item-list 1 --owner @me --query "label:bug status:In\\ Progress"
```

## 全コマンド詳細

各コマンドの詳細は [commands.md](references/commands.md) を参照。