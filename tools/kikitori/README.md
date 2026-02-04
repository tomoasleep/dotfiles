# kikitori

Whisper + Ollama を使った文字起こし CLI

## 必要条件

- Bun
- SoX (録音用)
  ```bash
  # macOS
  brew install sox
  ```
- Ollama (テキスト整形用)
  ```bash
  brew install ollama
  ```
- Whisper モデルファイル

## インストール

```bash
bun install
bun run build
```

## モデルのダウンロード

https://huggingface.co/ggerganov/whisper.cpp

## 使い方

### 基本的な文字起こし
```bash
./dist/index.js
# または
bun run dev
```

### テンプレートを使った出力
```bash
./dist/index.js --template ./template.md
```

### オプション
- `--template <path>`: テンプレートファイルのパス
- `--model <path>`: Whisper モデルファイルのパス
- `--duration <seconds>`: 録音時間（秒）、指定しない場合は Ctrl+C で停止
- `--language <code>`: 言語コード（デフォルト: ja）

## テンプレートの書き方

Handlebars 構文を使用。以下の変数が利用可能：

- `{{transcription}}`: 文字起こしされたテキスト

例：
```markdown
# 議事録

## 内容
{{transcription}}
```
