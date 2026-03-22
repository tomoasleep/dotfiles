---
name: obsidian-cli
description: "Obsidian CLI で Obsidian Vault を操作する。Use when: (1) Obsidian のノートを CLI から作成/編集/検索, (2) プラグイン/テーマの管理, (3) テンプレートの適用, (4) タスクやプロパティの操作"
---

# Obsidian CLI

Obsidian 1.12.4+ に搭載された公式 CLI で Vault を操作する。

## 設計原則

CLI は実行中の Obsidian アプリへの「リモートコントロール」。ファイル操作はすべて Obsidian の内部 API を経由し、wikilink の自動更新やインデックス反映が保証される。

## セットアップ

1. Obsidian 1.12.4+ に更新
2. Settings > General > Command line interface を有効化
3. ターミナルで `obsidian --version` を確認

## 基本パターン

```bash
obsidian <command> [subcommand] [options]
```

### よく使うオプション

| オプション | 説明 |
|-----------|------|
| `--vault <path>` | Vault パス指定 |
| `--file <path>` | 対象ファイル指定（Vault 内の相対パス） |
| `--json` | JSON 形式で出力 |
| `--help` | ヘルプ表示 |

### TUI モード

```bash
obsidian tui
```

## Quick Commands

### ファイル操作

```bash
obsidian file read --vault ~/Notes --file "Journal/Today.md"
obsidian file create --vault ~/Notes --file "New Note.md" --content "Body text"
obsidian file append --vault ~/Notes --file "Journal/Today.md" --content "\nAppended"
obsidian file move --vault ~/Notes --file "Old.md" --to "Folder/New.md"
obsidian file delete --vault ~/Notes --file "Delete.md"
obsidian open --vault ~/Notes --file "Note.md"
```

### 検索

```bash
obsidian search --vault ~/Notes "query"
obsidian search:context --vault ~/Notes "query"
obsidian backlinks --vault ~/Notes --file "Note.md"
obsidian links --vault ~/Notes --file "Note.md"
obsidian orphans --vault ~/Notes
```

### Daily Notes

```bash
obsidian daily --vault ~/Notes
obsidian daily:path --vault ~/Notes
obsidian daily:read --vault ~/Notes
obsidian daily:append --vault ~/Notes --content "- Task item"
obsidian daily:prepend --vault ~/Notes --content "# Header"
```

### タスク

```bash
obsidian tasks --vault ~/Notes
obsidian task --vault ~/Notes --file "Project.md" --content "- [ ] New task"
```

### テンプレート

```bash
obsidian template:insert --vault ~/Notes --file "Note.md" --template "Templates/Meeting.md"
```

### プロパティ

```bash
obsidian properties --vault ~/Notes --file "Note.md"
obsidian property:set --vault ~/Notes --file "Note.md" --key "status" --value "done"
obsidian property:read --vault ~/Notes --file "Note.md" --key "status"
```

### プラグイン

```bash
obsidian plugins --vault ~/Notes
obsidian plugin:enable --vault ~/Notes --plugin "dataview"
obsidian plugin:disable --vault ~/Notes --plugin "dataview"
obsidian plugin:install --vault ~/Notes --plugin "calendar"
obsidian plugin:uninstall --vault ~/Notes --plugin "calendar"
```

### テーマ

```bash
obsidian themes --vault ~/Notes
obsidian theme:set --vault ~/Notes --theme "Minimal"
obsidian theme:install --vault ~/Notes --theme "Minimal"
```

### その他

```bash
obsidian random --vault ~/Notes
obsidian tags --vault ~/Notes
obsidian outline --vault ~/Notes --file "Note.md"
obsidian version
obsidian reload --vault ~/Notes
```

## 全コマンド詳細

各コマンドの詳細は [commands.md](references/commands.md) を参照。
