---
name: manage-github-issue-dependencies
description: GitHub Issueの依存関係（dependencies）を作成・削除・一覧表示する。Use when Claude needs to: (1) Create blocked-by relationships between issues, (2) Create blocking relationships between issues, (3) Remove issue dependencies, (4) List blocked-by or blocking issues
---

## Quick start

Issueの依存関係を管理:

1. **依存関係を追加**（Issue #1がIssue #2にブロックされる）:
   ```bash
   ruby ~/.claude/skills/manage-github-issue-dependencies/scripts/add_dependency.rb owner/repo 1 2
   ```

2. **依存関係を削除**:
   ```bash
   ruby ~/.claude/skills/manage-github-issue-dependencies/scripts/remove_dependency.rb owner/repo 1 2
   ```

3. **ブロックされているIssueを一覧表示**:
   ```bash
   ruby ~/.claude/skills/manage-github-issue-dependencies/scripts/list_blocked_by.rb owner/repo 1
   ```

4. **ブロックしているIssueを一覧表示**:
   ```bash
   ruby ~/.claude/skills/manage-github-issue-dependencies/scripts/list_blocking.rb owner/repo 1
   ```

## GitHub REST API

### Add a dependency (issue is blocked by)

POST `/repos/{owner}/{repo}/issues/{issue_number}/dependencies/blocked_by`

Request body:
```json
{
  "issue_id": <id_of_blocking_issue>
}
```

### Remove a dependency (issue is blocked by)

DELETE `/repos/{owner}/{repo}/issues/{issue_number}/dependencies/blocked_by/{issue_id}`

### List dependencies an issue is blocked by

GET `/repos/{owner}/{repo}/issues/{issue_number}/dependencies/blocked_by`

### List dependencies an issue is blocking

GET `/repos/{owner}/{repo}/issues/{issue_number}/dependencies/blocking`

## Workflow

1. リポジトリとIssue番号を確認
2. 適切なスクリプトを実行
3. 結果を確認

## Notes

- GitHub Issueのdependenciesは最大50個まで設定可能
- blocked-by は「そのIssueがどのIssueにブロックされているか」
- blocking は「そのIssueがどのIssueをブロックしているか」
- Issue IDはIssue番号とは異なる（APIレスポンスの`id`フィールド）
