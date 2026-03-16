# Common Options for `gh project`

全ての `gh project` サブコマンドで使用可能な共通オプションの詳細。

## `--format json`

JSON形式で出力。デフォルトは人間が読みやすい形式。

```bash
gh project list --owner @me --format json
```

出力例:
```json
[
  {
    "id": "PVT_...",
    "number": 1,
    "title": "My Project",
    "url": "https://github.com/users/monalisa/projects/1",
    "closed": false,
    "createdAt": "2024-01-15T10:30:00Z",
    "updatedAt": "2024-02-20T15:45:00Z"
  }
]
```

## `--jq <expression>`

jq 式で JSON 出力をフィルタリング。`--format json` と組み合わせて使用。

```bash
gh project list --owner @me --format json --jq '.[] | .title'
gh project item-list 1 --owner @me --format json --jq '.[] | select(.status=="In Progress") | .title'
```

よく使う jq 式:

| 目的 | jq式 |
|------|------|
| タイトル一覧 | `.[] \| .title` |
| 特定ステータス | `.[] \| select(.status=="Done")` |
| IDとタイトル | `.[] \| {id, title}` |
| 最初の1件 | `.[0]` |
| 件数 | `length` |

## `--owner <login>`

プロジェクトのオーナーを指定。

| 値 | 説明 |
|----|------|
| `@me` | 現在のユーザー |
| `monalisa` | ユーザー名 |
| `github` | 組織名 |

```bash
gh project list --owner @me
gh project list --owner myorg
```

URLからの対応:
| URL | --owner | project number |
|-----|---------|----------------|
| `https://github.com/users/monalisa/projects/1` | `monalisa` | `1` |
| `https://github.com/orgs/github/projects/5` | `github` | `5` |

## `--limit <n>`

取得する件数の上限。デフォルトは30。

```bash
gh project list --owner github --limit 100
gh project item-list 1 --owner @me --limit 50
```

## `-t, --template <template>`

Go テンプレートでフォーマット。

```bash
gh project list --owner @me --format json -t '{{range .}}{{.title}}{{"\n"}}{{end}}'
gh project item-list 1 --owner @me --format json -t '{{.number}}: {{.title}}{{"\n"}}'
```

## `-w, --web`

ブラウザで開く。

```bash
gh project view 1 --owner @me --web
gh project list --owner github --web
```

## `--closed`

`gh project list` で使用。クローズ済みプロジェクトも含める。

```bash
gh project list --owner @me --closed
```

## グローバルオプション

`gh` コマンド全体で有効なオプション:

| オプション | 説明 |
|-----------|------|
| `--help` | ヘルプを表示 |
| `-R, --repo <repo>` | リポジトリを指定（一部サブコマンド） |