---
name: skill-script-path-safety
description: Skillの利用時に scripts の相対パス解決ミスを防ぐための実行手順。相対パス、cwd、No such file or directory、./scripts、scripts/ が出る文脈では必ずこのSkillを使って、Skill Base Directory基準で絶対パス実行に正規化する。
---

# Skill Script Path Safety

## 目的

Skill内の `scripts/` を実行するときに、カレントディレクトリ基準で誤って解決して失敗する問題を防ぐ。

## 適用タイミング

- Skillを利用していて `scripts/...` が登場したとき
- `./scripts/...` を実行しようとしているとき
- `No such file or directory` が出たとき
- パス基準が曖昧なとき

## 必須ルール

1. Skill内の相対パスは `cwd` ではなく Skill Base Directory 基準で解決する。
2. 実行時は必ず絶対パスを使う。
3. `workdir` は対象プロジェクト操作用であり、Skillスクリプトの場所解決には使わない。
4. 実行前に対象スクリプトの存在を確認する。

## 実行手順

1. Skillロード結果から `Base directory for this skill` を特定する。
2. Skillに書かれた `scripts/foo.sh` や `scripts/foo.py` を `<BASE>/scripts/foo.sh` のように正規化する。
3. Read または Glob で `<BASE>/scripts/...` の存在確認を行う。
4. Bash では絶対パスを指定して実行する。

## 具体例

前提:

- `cwd`: `/Users/me/project-a`
- Skill Base Directory: `/Users/me/.config/opencode/skills/my-skill`
- 実行対象: `scripts/check.sh`

Before (失敗しやすい):

```bash
./scripts/check.sh
```

この場合は `/Users/me/project-a/scripts/check.sh` を参照してしまう。

After (正しい):

```bash
bash "/Users/me/.config/opencode/skills/my-skill/scripts/check.sh"
```

`cwd` がどこでも同じ結果になる。

## 入出力サンプル

入力:

```text
scripts/collect.py を実行して
```

出力（実行フロー）:

1. Base directory を取得する。
2. `scripts/collect.py` を `/abs/path/to/skill/scripts/collect.py` に正規化する。
3. 存在確認後、`python "/abs/path/to/skill/scripts/collect.py"` で実行する。

## NG / OK パターン

- NG: `./scripts/foo.sh`
- NG: `python scripts/foo.py`
- OK: `bash "/abs/path/to/skill/scripts/foo.sh"`
- OK: `python "/abs/path/to/skill/scripts/foo.py"`

## 失敗時のリカバリ

1. Base directory が分からない場合は Skill を再ロードして `Base directory for this skill` を確認する。
2. 正規化後の絶対パスをそのままユーザーに提示し、どのパスを参照したかを明示する。
