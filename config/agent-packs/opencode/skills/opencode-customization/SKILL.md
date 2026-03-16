---
name: opencode-customization
description: OpenCodeのカスタマイズ方法を包括的にガイド。設定ファイル、Agent Skills、Custom Tools、Custom Commands、Custom Agents、Themes、Keybinds、Formatters、Permissions、MCP Serversの設定方法について説明します
---

# OpenCode Customization

## 概要

OpenCodeは設定ファイルやAgent Skills、Custom Toolsなどを通じてカスタマイズ可能です。このSkillでは、OpenCodeの全般的なカスタマイズ方法をガイドします。

## 設定ファイルの概要

OpenCodeは以下の場所から設定を読み込みます（順序に従ってマージされます）：

1. **Remote config** (`.well-known/opencode`) - 組織のデフォルト設定
2. **Global config** (`~/.config/opencode/opencode.json`) - ユーザー設定
3. **Custom config** (`OPENCODE_CONFIG`環境変数) - カスタム設定
4. **Project config** (`opencode.json` in プロジェクト) - プロジェクト固有設定
5. **`.opencode` directories** - agents、commands、plugins
6. **Inline config** (`OPENCODE_CONFIG_CONTENT`環境変数) - ランタイム設定

詳細は[config-files.md](references/config-files.md)を参照

## Agent Skills

Agent Skillsは再利用可能な振る舞いをSKILL.md定義で定義します。特定のドメインやタスクのための「オンボーディングガイド」として機能します。

詳細は[agent-skills.md](references/agent-skills.md)を参照

## Custom Tools

OpenCodeはカスタムツールを作成可能です。これにより、特定のタスクの自動化や外部サービスとの統合が可能になります。

詳細は[custom-tools.md](references/custom-tools.md)を参照

## Custom Commands

反復的なタスクのためにカスタムコマンドを設定できます。

詳細は[custom-commands.md](references/custom-commands.md)を参照

## Custom Agents

特定のタスク向けの特殊なエージェントを設定できます。

詳細は[custom-agents.md](references/custom-agents.md)を参照

## Themes

テーマをカスタマイズできます。

詳細は[themes.md](references/themes.md)を参照

## Keybinds

キーバインドをカスタマイズできます。

詳細は[keybinds.md](references/keybinds.md)を参照

## Formatters

コードフォーマッタを設定できます。

詳細は[formatters.md](references/formatters.md)を参照

## Permissions

操作に対する権限設定が可能です。

詳細は[permissions.md](references/permissions.md)を参照

## MCP Servers

MCPサーバを設定できます。

詳細は[mcp-servers.md](references/mcp-servers.md)を参照

## 使用例

### 例1: プロジェクト固有の設定を作成する

```
opencode.jsonを作成して、プロジェクト固有のモデルとテーマを設定する
```

### 例2: 新しいAgent Skillを作成する

```
SKILL.mdを.opencode/skills/my-skill/に作成して、再利用可能な振る舞いを定義する
```

### 例3: カスタムコマンドを定義する

```
opencode.jsonでcommandオプションを設定して、反復的なタスクをコマンド化する
```
