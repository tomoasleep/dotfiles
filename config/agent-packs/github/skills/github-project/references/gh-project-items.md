# gh-project-items

GitHub Project のアイテム一覧を JSON で取得するヘルパー。

## Usage

このスキルの配置場所 (SKILL.md があるディレクトリ) からの相対パスで実行:

```bash
$SKILL_DIR/scripts/gh-project-items <project-number> --owner <owner> [--column <name>] [--limit <n>]
```

## Options

| Option | Description |
|--------|-------------|
| `--owner <login>` | オーナー指定（`@me` など） |
| `--column <name>` | ステータスカラム名でフィルタ（例: `Ready`, `In Progress`） |
| `--limit <n>` | 取得件数（デフォルト30） |

## Examples

```bash
$SKILL_DIR/scripts/gh-project-items 1 --owner @me
$SKILL_DIR/scripts/gh-project-items 1 --owner @me --column "Ready"
```

## Output

```json
[
  {
    "id": "PVTI_...",
    "title": "Task title",
    "url": "https://github.com/...",
    "status": "Ready"
  }
]
```
