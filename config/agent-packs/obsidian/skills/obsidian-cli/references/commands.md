# Obsidian CLI Commands Reference

全コマンドの詳細リファレンス。

## General Commands

### help
```bash
obsidian help
obsidian <command> --help
```

### version
```bash
obsidian --version
obsidian version
```

### reload
Vault をリロード。
```bash
obsidian reload --vault <path>
```

### restart
Obsidian を再起動。
```bash
obsidian restart --vault <path>
```

## Files and Folders

### file
ファイル情報を表示。
```bash
obsidian file --vault <path> --file <relative-path>
obsidian file read --vault <path> --file <relative-path>
```

### files
Vault 内のファイル一覧。
```bash
obsidian files --vault <path>
obsidian files --vault <path> --folder "Folder"
```

### folder
フォルダ情報。
```bash
obsidian folder --vault <path> --folder <relative-path>
```

### folders
フォルダ一覧。
```bash
obsidian folders --vault <path>
```

### create
ファイル作成。
```bash
obsidian create --vault <path> --file <relative-path> --content "content"
```

### read
ファイル読み込み。
```bash
obsidian read --vault <path> --file <relative-path>
```

### append
ファイル末尾に追記。
```bash
obsidian append --vault <path> --file <relative-path> --content "content"
```

### prepend
ファイル先頭に追記。
```bash
obsidian prepend --vault <path> --file <relative-path> --content "content"
```

### move
ファイル移動（wikilink 自動更新）。
```bash
obsidian move --vault <path> --file <from> --to <to>
```

### rename
ファイル名変更。
```bash
obsidian rename --vault <path> --file <path> --name "New Name.md"
```

### delete
ファイル削除。
```bash
obsidian delete --vault <path> --file <relative-path>
```

### open
Obsidian でファイルを開く。
```bash
obsidian open --vault <path> --file <relative-path>
```

## Search

### search
クエリで検索。
```bash
obsidian search --vault <path> "search query"
obsidian search --vault <path> "tag:#project"
```

### search:context
検索結果にコンテキストを含める。
```bash
obsidian search:context --vault <path> "query"
```

### search:open
検索結果を Obsidian で開く。
```bash
obsidian search:open --vault <path> "query"
```

## Links

### backlinks
ファイルへのバックリンク一覧。
```bash
obsidian backlinks --vault <path> --file <relative-path>
```

### links
ファイルからのリンク一覧。
```bash
obsidian links --vault <path> --file <relative-path>
```

### unresolved
未解決リンク一覧。
```bash
obsidian unresolved --vault <path>
```

### orphans
リンクされていないファイル一覧。
```bash
obsidian orphans --vault <path>
```

### deadends
外部へのリンクがないファイル一覧。
```bash
obsidian deadends --vault <path>
```

## Daily Notes

### daily
今日のデイリーノートを開く。
```bash
obsidian daily --vault <path>
```

### daily:path
今日のデイリーノートのパスを取得。
```bash
obsidian daily:path --vault <path>
```

### daily:read
今日のデイリーノートを読み込み。
```bash
obsidian daily:read --vault <path>
```

### daily:append
今日のデイリーノートに追記。
```bash
obsidian daily:append --vault <path> --content "content"
```

### daily:prepend
今日のデイリーノートの先頭に追記。
```bash
obsidian daily:prepend --vault <path> --content "content"
```

## Tasks

### tasks
Vault 内の全タスク一覧。
```bash
obsidian tasks --vault <path>
```

### task
特定ファイルのタスク操作。
```bash
obsidian task --vault <path> --file <relative-path> --content "- [ ] Task"
```

## Templates

### templates
テンプレート一覧。
```bash
obsidian templates --vault <path>
```

### template:read
テンプレート内容を読み込み。
```bash
obsidian template:read --vault <path> --template <template-path>
```

### template:insert
テンプレートをファイルに挿入。
```bash
obsidian template:insert --vault <path> --file <relative-path> --template <template-path>
```

## Properties (Frontmatter)

### aliases
エイリアス一覧。
```bash
obsidian aliases --vault <path> --file <relative-path>
```

### properties
ファイルのプロパティ一覧。
```bash
obsidian properties --vault <path> --file <relative-path>
```

### property:set
プロパティを設定。
```bash
obsidian property:set --vault <path> --file <relative-path> --key <key> --value <value>
obsidian property:set --vault <path> --file <relative-path> --key tags --value '["tag1", "tag2"]'
```

### property:remove
プロパティを削除。
```bash
obsidian property:remove --vault <path> --file <relative-path> --key <key>
```

### property:read
プロパティ値を読み込み。
```bash
obsidian property:read --vault <path> --file <relative-path> --key <key>
```

## Plugins

### plugins
インストール済みプラグイン一覧。
```bash
obsidian plugins --vault <path>
```

### plugins:enabled
有効なプラグイン一覧。
```bash
obsidian plugins:enabled --vault <path>
```

### plugins:restrict
セキュアモード設定。
```bash
obsidian plugins:restrict --vault <path> --on
obsidian plugins:restrict --vault <path> --off
```

### plugin
プラグイン情報。
```bash
obsidian plugin --vault <path> --plugin <plugin-id>
```

### plugin:enable
プラグインを有効化。
```bash
obsidian plugin:enable --vault <path> --plugin <plugin-id>
```

### plugin:disable
プラグインを無効化。
```bash
obsidian plugin:disable --vault <path> --plugin <plugin-id>
```

### plugin:install
コミュニティプラグインをインストール。
```bash
obsidian plugin:install --vault <path> --plugin <plugin-id>
```

### plugin:uninstall
プラグインをアンインストール。
```bash
obsidian plugin:uninstall --vault <path> --plugin <plugin-id>
```

### plugin:reload
プラグインをリロード。
```bash
obsidian plugin:reload --vault <path> --plugin <plugin-id>
```

## Themes and Snippets

### themes
テーマ一覧。
```bash
obsidian themes --vault <path>
```

### theme
テーマ情報。
```bash
obsidian theme --vault <path> --theme <theme-id>
```

### theme:set
テーマを適用。
```bash
obsidian theme:set --vault <path> --theme <theme-id>
```

### theme:install
コミュニティテーマをインストール。
```bash
obsidian theme:install --vault <path> --theme <theme-id>
```

### theme:uninstall
テーマをアンインストール。
```bash
obsidian theme:uninstall --vault <path> --theme <theme-id>
```

### snippets
CSS スニペット一覧。
```bash
obsidian snippets --vault <path>
```

### snippets:enabled
有効な CSS スニペット一覧。
```bash
obsidian snippets:enabled --vault <path>
```

## Publish

### publish:site
Publish サイト情報。
```bash
obsidian publish:site --vault <path>
```

### publish:list
Publish 済みファイル一覧。
```bash
obsidian publish:list --vault <path>
```

### publish:status
Publish ステータス。
```bash
obsidian publish:status --vault <path>
```

### publish:add
ファイルを Publish 対象に追加。
```bash
obsidian publish:add --vault <path> --file <relative-path>
```

### publish:remove
ファイルを Publish 対象から削除。
```bash
obsidian publish:remove --vault <path> --file <relative-path>
```

### publish:open
Publish サイトをブラウザで開く。
```bash
obsidian publish:open --vault <path>
```

## Sync

### sync
同期状態。
```bash
obsidian sync --vault <path>
```

### sync:status
同期ステータス。
```bash
obsidian sync:status --vault <path>
```

### sync:history
同期履歴。
```bash
obsidian sync:history --vault <path> --file <relative-path>
```

### sync:read
同期履歴からバージョンを読み込み。
```bash
obsidian sync:read --vault <path> --file <relative-path> --revision <id>
```

### sync:restore
同期履歴から復元。
```bash
obsidian sync:restore --vault <path> --file <relative-path> --revision <id>
```

### sync:open
同期履歴を Obsidian で開く。
```bash
obsidian sync:open --vault <path> --file <relative-path>
```

### sync:deleted
削除されたファイル一覧。
```bash
obsidian sync:deleted --vault <path>
```

## File History

### diff
ファイルの差分を表示。
```bash
obsidian diff --vault <path> --file <relative-path>
```

### history
ファイル履歴。
```bash
obsidian history --vault <path> --file <relative-path>
```

### history:list
履歴一覧。
```bash
obsidian history:list --vault <path> --file <relative-path>
```

### history:read
履歴からバージョンを読み込み。
```bash
obsidian history:read --vault <path> --file <relative-path> --revision <id>
```

### history:restore
履歴から復元。
```bash
obsidian history:restore --vault <path> --file <relative-path> --revision <id>
```

### history:open
履歴を Obsidian で開く。
```bash
obsidian history:open --vault <path> --file <relative-path>
```

## Bases

### bases
Bases 一覧。
```bash
obsidian bases --vault <path>
```

### base:views
Base のビュー一覧。
```bash
obsidian base:views --vault <path> --file <relative-path>
```

### base:create
Base を作成。
```bash
obsidian base:create --vault <path> --file <relative-path>
```

### base:query
Base にクエリを実行。
```bash
obsidian base:query --vault <path> --file <relative-path> "query"
```

## Bookmarks

### bookmarks
ブックマーク一覧。
```bash
obsidian bookmarks --vault <path>
```

### bookmark
ブックマーク操作。
```bash
obsidian bookmark --vault <path> --file <relative-path>
```

## Command Palette

### commands
コマンド一覧。
```bash
obsidian commands --vault <path>
```

### command
コマンドを実行。
```bash
obsidian command --vault <path> --id <command-id>
```

### hotkeys
ホットキー一覧。
```bash
obsidian hotkeys --vault <path>
```

### hotkey
ホットキー操作。
```bash
obsidian hotkey --vault <path> --id <command-id>
```

## Outline

### outline
ファイルのアウトライン（見出し構造）。
```bash
obsidian outline --vault <path> --file <relative-path>
```

## Random Notes

### random
ランダムなノートを開く。
```bash
obsidian random --vault <path>
```

### random:read
ランダムなノートを読み込み。
```bash
obsidian random:read --vault <path>
```

## Tags

### tags
タグ一覧。
```bash
obsidian tags --vault <path>
```

### tag
特定タグの情報。
```bash
obsidian tag --vault <path> --name <tag-name>
```
