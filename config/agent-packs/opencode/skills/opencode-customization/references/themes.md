# Themes

## 概要

ビルトインテーマを選択するか、独自のカスタムテーマを定義できます。

## ビルトインテーマ

`system`, `tokyonight`, `everforest`, `ayu`, `catppuccin`, `gruvbox`, `kanagawa`, `nord`, `matrix`, `one-dark` など

## 使用方法

```json
{
  "theme": "tokyonight"
}
```

## カスタムテーマ

`~/.config/opencode/themes/*.json` または `.opencode/themes/*.json` にJSONで定義。

```json
{
  "$schema": "https://opencode.ai/theme.json",
  "theme": {
    "primary": "#88C0D0",
    "text": "#D8DEE9",
    "background": "#2E3440"
  }
}
```

## 公式ドキュメントの内容

- ターミナル要件（truecolorサポート）
- 階層（ビルトイン → ユーザー設定 → プロジェクト → 現在ディレクトリ）
- JSONフォーマット（Hex色、ANSI色、色参照、ダーク/ライトバリアント）
- 色定義（defsセクション）
- 詳細な例

## 参照タイミング

以下の場合に公式ドキュメントを確認してください：

- カスタムテーマの作成方法を詳しく知りたい場合
- JSONフォーマットや色定義の詳しい使い方を知りたい場合
- 詳細な例を参照したい場合

## 公式ドキュメント

https://opencode.ai/docs/themes
