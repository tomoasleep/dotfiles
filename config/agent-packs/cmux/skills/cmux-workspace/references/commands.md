# cmux Commands Reference

完全なコマンドリファレンス。

## 基本

```bash
cmux version
cmux ping
cmux capabilities
cmux identify [--workspace <id>] [--surface <id>] [--no-caller]
```

## Socket Auth

- `--password <text>` - パスワード認証
- `CMUX_SOCKET_PASSWORD` - 環境変数
- キーチェーンに保存されたパスワード

## Workspace

```bash
cmux list-workspaces
cmux current-workspace
cmux new-workspace [--command <text>]
cmux select-workspace --workspace <id>
cmux close-workspace --workspace <id>
cmux rename-workspace [--workspace <id>] <title>
cmux reorder-workspace --workspace <id> (--index <n> | --before <id> | --after <id>) [--window <id>]
```

## Window

```bash
cmux list-windows
cmux current-window
cmux new-window
cmux focus-window --window <id>
cmux close-window --window <id>
cmux rename-window [--workspace <id>] <title>
cmux next-window
cmux previous-window
cmux last-window
```

## Workspace <-> Window

```bash
cmux move-workspace-to-window --workspace <id> --window <id>
```

## Pane

```bash
cmux list-panes [--workspace <id>]
cmux new-pane [--type <terminal|browser>] [--direction <left|right|up|down>] [--workspace <id>] [--url <url>]
cmux focus-pane --pane <id> [--workspace <id>]
cmux last-pane [--workspace <id>]
```

## Surface

```bash
cmux list-pane-surfaces [--workspace <id>] [--pane <id>]
cmux new-surface [--type <terminal|browser>] [--pane <id>] [--workspace <id>] [--url <url>]
cmux close-surface [--surface <id>] [--workspace <id>]
cmux move-surface --surface <id> [--pane <id>] [--workspace <id>] [--window <id>] [--before <id>] [--after <id>] [--index <n>] [--focus <true|false>]
cmux reorder-surface --surface <id> (--index <n> | --before <id> | --after <id>)
cmux drag-surface-to-split --surface <id> <left|right|up|down>
cmux refresh-surfaces
cmux surface-health [--workspace <id>]
cmux trigger-flash [--workspace <id>] [--surface <id>]
```

## Split

```bash
cmux new-split <left|right|up|down> [--workspace <id>] [--surface <id>] [--panel <id>]
```

## Tab

```bash
cmux tab-action --action <name> [--tab <id>] [--surface <id>] [--workspace <id>] [--title <text>] [--url <url>]
cmux rename-tab [--workspace <id>] [--tab <id>] [--surface <id>] <title>
```

## Panel

```bash
cmux list-panels [--workspace <id>]
cmux focus-panel --panel <id> [--workspace <id>]
```

## Send / Read

```bash
cmux send [--workspace <id>] [--surface <id>] <text>
cmux send-key [--workspace <id>] [--surface <id>] <key>
cmux send-panel --panel <id> [--workspace <id>] <text>
cmux send-key-panel --panel <id> [--workspace <id>] <key>
cmux read-screen [--workspace <id>] [--surface <id>] [--scrollback] [--lines <n>]
```

## Notify

```bash
cmux notify --title <text> [--subtitle <text>] [--body <text>] [--workspace <id>] [--surface <id>]
cmux list-notifications
cmux clear-notifications
```

## Sidebar Metadata

```bash
cmux set-status <key> <value> [--icon <name>] [--color <#hex>] [--workspace <id>]
cmux clear-status <key> [--workspace <id>]
cmux list-status [--workspace <id>]
cmux set-progress <0.0-1.0> [--label <text>] [--workspace <id>]
cmux clear-progress [--workspace <id>]
cmux log [--level <level>] [--source <name>] [--workspace <id>] [--] <message>
cmux clear-log [--workspace <id>]
cmux list-log [--limit <n>] [--workspace <id>]
cmux sidebar-state [--workspace <id>]
```

## App Focus

```bash
cmux set-app-focus <active|inactive|clear>
cmux simulate-app-active
```

## Claude Hook

```bash
cmux claude-hook <session-start|stop|notification> [--workspace <id>] [--surface <id>]
```

## tmux Compatibility

```bash
cmux capture-pane [--workspace <id>] [--surface <id>] [--scrollback] [--lines <n>]
cmux resize-pane --pane <id> [--workspace <id>] (-L|-R|-U|-D) [--amount <n>]
cmux pipe-pane --command <shell-command> [--workspace <id>] [--surface <id>]
cmux wait-for [-S|--signal] <name> [--timeout <seconds>]
cmux swap-pane --pane <id> --target-pane <id> [--workspace <id>]
cmux break-pane [--workspace <id>] [--pane <id>] [--surface <id>] [--no-focus]
cmux join-pane --target-pane <id> [--workspace <id>] [--pane <id>] [--surface <id>] [--no-focus]
cmux find-window [--content] [--select] <query>
cmux clear-history [--workspace <id>] [--surface <id>]
cmux set-hook [--list] [--unset <event>] | <event> <command>
cmux popup
cmux bind-key | unbind-key | copy-mode
cmux set-buffer [--name <name>] <text>
cmux list-buffers
cmux paste-buffer [--name <name>] [--workspace <id>] [--surface <id>]
cmux respawn-pane [--workspace <id>] [--surface <id>] [--command <cmd>]
cmux display-message [-p|--print] <text>
```

## Browser

```bash
cmux browser [--surface <id>] <subcommand> ...
cmux browser open [url]
cmux browser open-split [url]
cmux browser goto|navigate <url> [--snapshot-after]
cmux browser back|forward|reload [--snapshot-after]
cmux browser url|get-url
cmux browser snapshot [--interactive|-i] [--cursor] [--compact] [--max-depth <n>] [--selector <css>]
cmux browser eval <script>
cmux browser wait [--selector <css>] [--text <text>] [--url-contains <text>] [--load-state <interactive|complete>] [--function <js>] [--timeout-ms <n>]
cmux browser click|dblclick|hover|focus|check|uncheck|scroll-into-view <selector> [--snapshot-after]
cmux browser type <selector> <text> [--snapshot-after]
cmux browser fill <selector> [text] [--snapshot-after]
cmux browser press|keydown|keyup <key> [--snapshot-after]
cmux browser select <selector> <value> [--snapshot-after]
cmux browser scroll [--selector <css>] [--dx <n>] [--dy <n>] [--snapshot-after]
cmux browser get <url|title|text|html|value|attr|count|box|styles> [...]
cmux browser is <visible|enabled|checked> <selector>
cmux browser find <role|text|label|placeholder|alt|title|testid|first|last|nth> ...
cmux browser frame <selector|main>
cmux browser dialog <accept|dismiss> [text]
cmux browser download [wait] [--path <path>] [--timeout-ms <n>]
cmux browser cookies <get|set|clear> [...]
cmux browser storage <local|session> <get|set|clear> [...]
cmux browser tab <new|list|switch|close|<index>> [...]
cmux browser console <list|clear>
cmux browser errors <list|clear>
cmux browser highlight <selector>
cmux browser state <save|load> <path>
cmux browser addinitscript <script>
cmux browser addscript <script>
cmux browser addstyle <css>
cmux browser viewport <width> <height>
cmux browser geolocation|geo <lat> <lon>
cmux browser offline <true|false>
cmux browser trace <start|stop> [path]
cmux browser network <route|unroute|requests> [...]
cmux browser screencast <start|stop>
cmux browser input <mouse|keyboard|touch>
cmux browser identify [--surface <id>]
```

## Legcy Browser Aliases

```bash
cmux open-browser
cmux navigate <url>
cmux browser-back
cmux browser-forward
cmux browser-reload
cmux get-url
```