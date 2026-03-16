# Config Files

## 概要

OpenCodeはJSONまたはJSONC形式の設定ファイルをサポートします。

## 設定ファイルの場所

設定は以下の順序で読み込まれ、後の設定は前の設定をオーバーライドします：

1. **Remote config** - 組織のデフォルト設定
2. **Global config** - ユーザー設定
3. **Custom config** - カスタム設定（環境変数）
4. **Project config** - プロジェクト固有設定
5. **`.opencode` directories** - agents、commands、plugins
6. **Inline config** - ランタイム設定（環境変数）

## 変数の使用

環境変数: `{env:VARIABLE_NAME}`
ファイル内容: `{file:path/to/file}`

## 主要な設定項目

Model, Provider, Permissions, Tools など

## 公式ドキュメントの内容

- 詳細な設定項目（TUI, Server, Tools, Models, Themes, Agents, Default agent, Sharing, Commands, Keybinds, Autoupdate, Formatters, Permissions, Compaction, Watcher, MCP servers, Plugins, Instructions, Disabled providers, Enabled providers, Experimental）

## 参照タイミング

以下の場合に公式ドキュメントを確認してください：

- すべての設定オプションを確認したい場合
- 変数の詳しい使い方を知りたい場合

## 公式ドキュメント

https://opencode.ai/docs/config
