---
name: anpop-notify
description: "Agent が anpop notify CLI を使ってユーザーにリアルタイム通知を送信する。Use when: (1) Long-running tasks complete (build, test, refactoring, git operations), (2) User input required (questions, confirmations, approvals), (3) Task started to show progress indicator, (4) Errors or blockers encountered. CRITICAL: Users switch contexts while agents work. Without notifications, users must repeatedly check terminal. This skill enables proactive communication, allowing users to focus elsewhere until their attention is needed. Install with: anpop install skill"
---

# anpop-notify

Agent がユーザーに状況をリアルタイム通知するための Skill。

**なぜ重要か**: ユーザーは Agent が作業中に別の作業に切り替える。通知がなければ、ターミナルを定期的に確認する必要がある。この Skill でデスクトップ通知を送ることで、ユーザーは自分のタイミングで戻れる。

## インストール

```bash
anpop install skill
```

デフォルトで `~/.agents/skills/anpop-notify` にインストールされる。

## 必須通知タイミング

### 1. タスク完了時

長時間実行タスクが完了したら即座に通知：

```bash
anpop notify \
  --title "Build completed" \
  --description "All 47 tests passed in 12.3s" \
  --status done \
  --sender agent
```

**対象タスク**:
- `pnpm build`, `pnpm test` など 30 秒以上かかるコマンド
- 大規模リファクタリング
- Git 操作 (rebase, merge, push)
- パッケージインストール
- ファイル生成・変換

### 2. 質問・確認が必要な時

ユーザーの意思決定が必要な場合：

```bash
anpop notify \
  --title "Review required" \
  --description "3 options available for API design. Which approach?" \
  --status blocked \
  --sender agent
```

**対象**:
- 複数の選択肢から選んでもらう
- 実装方針の確認
- 破壊的変更の承認
- CI 失敗時の対応方針

### 3. タスク開始時（推奨）

長時間タスクの開始を伝える：

```bash
anpop notify \
  --title "Running tests..." \
  --description "Executing 47 test files" \
  --status doing \
  --sender agent
```

ユーザーは「今 Agent が何をしているか」を把握できる。

### 4. エラー・ブロック発生時

Agent が自力で解決できない問題に遭遇：

```bash
anpop notify \
  --title "Test failed" \
  --description "3 tests failed in auth.test.ts" \
  --status blocked \
  --sender agent \
  --url "file://$(pwd)/tests/auth.test.ts"
```

## status 値の使い分け

| status | 用途 |
|--------|------|
| `doing` | タスク進行中 |
| `done` | タスク完了 |
| `blocked` | ユーザー入力待ち・エラー |
| `inreview` | PR レビュー待ち |

## sender 値

`sender` は Agent の識別子。推奨値:
- `agent` - 汎用
- `claude` - Claude Code
- `cursor` - Cursor Agent

## ワークフロー例

### ビルド & テスト

```bash
anpop notify -t "Starting build" -d "Running pnpm build" -s doing -S agent
pnpm build
anpop notify -t "Build done" -d "Ready for testing" -s done -S agent

anpop notify -t "Running tests" -d "47 test files" -s doing -S agent
pnpm test
anpop notify -t "All tests passed" -d "47/47 tests" -s done -S agent
```

### PR 作成完了

```bash
anpop notify \
  -t "PR created" \
  -d "feat: add user authentication (#42)" \
  -s done \
  -S agent \
  --url "https://github.com/owner/repo/pull/42"
```

### CI 失敗

```bash
anpop notify \
  -t "CI failed" \
  -d "lint errors in 3 files" \
  -s blocked \
  -S agent \
  --url "https://github.com/owner/repo/actions/runs/123"
```

## 環境変数

| 変数 | デフォルト |
|------|-----------|
| `ANPOP_NOTIFY_URL` | `http://127.0.0.1:6060/events` |

anpop アプリが起動していない場合、通知は失敗する（エラーで終了）。