# Zellij Bundler

Zellij プラグインを GitHub Releases から簡単にダウンロード・管理するためのツールです。

## インストール

```bash
# このリポジトリをクローン
git clone https://github.com/tomoasleep/zellij-bundler.git
cd zellij-bundler

# 依存関係をインストール
bundle install

# インストール
gem build zellij-bundler.gemspec
gem install zellij-bundler-*.gem
```

## 依存関係

- Ruby 2.7 以上
- GitHub CLI (gh)

## 使い方

### 初期化

新しい `zellij-bundles.rb` ファイルを作成します。

```bash
zellij-bundler init
```

### プラグインを定義

`zellij-bundles.rb` を編集して、インストールしたいプラグインを定義します。

```ruby
# Zellij Bundler Configuration

# Global settings
set :output_dir, './plugins'
set :force, false

# Plugins
plugin 'leakec/multitask'
plugin 'ndavd/zellij-cb'

# 特定のバージョンを指定
plugin 'cunialino/zellij-sessionizer', tag: 'v0.1.1'

# 出力先を個別に指定
plugin 'imsnif/monocle', to: '~/.zellij/plugins'

# wasm ファイル名を明示的に指定
plugin 'owner/repo', as: 'custom-name.wasm'

# ブロック形式での詳細設定
plugin 'owner/repo' do
  tag 'v1.0.0'
  to './custom/path'
  as 'custom-name.wasm'
end
```

### プラグインをインストール

定義されたすべてのプラグインをインストールします。

```bash
zellij-bundler bundle
```

### 個別にインストール

特定のプラグインのみインストールします。

```bash
zellij-bundler install leakec/multitask
```

### インストール済みプラグインを表示

```bash
zellij-bundler list
```

### プラグインを削除

```bash
zellij-bundler remove leakec/multitask
```

### プラグインを更新

すべてのプラグインを更新します。

```bash
zellij-bundler update all
```

特定のプラグインのみ更新します。

```bash
zellij-bundler update leakec/multitask
```

### Zellij 設定ファイルのテンプレートを表示

インストール済みのプラグインを元に Zellij の設定ファイル（KDL形式）に追加する内容を表示します。

```bash
zellij-bundler config-template
```

出力を Zellij の設定ファイルに追加します。

```bash
zellij-bundler config-template >> ~/.config/zellij/config.kdl
```

生成される設定の例：

```kdl
plugins {
  multitask location="file:./plugins/multitask.wasm"
  zellij-cb location="file:./plugins/zellij-cb.wasm"
}
```

## WASM ファイルの自動検出

zellij-bundler は以下のパターンで WASM ファイルを自動検出します:

1. リポジトリ名と同じ `.wasm` ファイル (例: `multitask` → `multitask.wasm`)
2. `zellij-` または `zellij_` プレフィックスを削除した名前の `.wasm` ファイル (例: `zellij-sessionizer` → `sessionizer.wasm`)

検出できない場合、利用可能なファイル一覧が表示され、対話的に選択できます。

## プロジェクト構成

```
zellij-bundler/
├── lib/
│   └── zellij_bundler/
│       ├── cli.rb                    # CLI 定義
│       ├── dsl.rb                    # DSL パーサー
│       ├── plugin.rb                 # プラグイン情報
│       ├── detector.rb               # WASM ファイル検出ロジック
│       ├── installer.rb              # インストール処理
│       ├── lockfile.rb               # ロックファイル管理
│       ├── config_template.rb        # Zellij 設定テンプレート生成
│       └── version.rb               # バージョン情報
├── bin/
│   └── zellij-bundler              # 実行スクリプト
├── Gemfile                         # 依存関係
└── zellij-bundler.gemspec          # gemspec
```

## ライセンス

MIT License

## 貢献

バグ報告やプルリクエストは歓迎します。
