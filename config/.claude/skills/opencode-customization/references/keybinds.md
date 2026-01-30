# Keybinds

## 概要

キーバインドをカスタマイズできます。

## 基本設定

```json
{
  "keybinds": {
    "leader": "ctrl+x",
    "command_list": "ctrl+p",
    "agent_cycle": "tab"
  }
}
```

## Leaderキー

デフォルトは`ctrl+x`。ほとんどのアクションは`leader`キー+ショートカット。

## キーバインドの無効化

```json
{
  "keybinds": {
    "session_compact": "none"
  }
}
```

## 公式ドキュメントの内容

- すべてのキーバインドオプションの一覧
- Desktop prompt shortcuts（Readline/Emacsスタイル）
- Shift+Enterの設定方法（Windows Terminalなど）

## 参照タイミング

以下の場合に公式ドキュメントを確認してください：

- すべてのキーバインドオプションを確認したい場合
- Desktop prompt shortcutsを知りたい場合
- Shift+Enterの設定が必要な場合

## 公式ドキュメント

https://opencode.ai/docs/keybinds
