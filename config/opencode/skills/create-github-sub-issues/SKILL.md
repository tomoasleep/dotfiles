---
name: create-github-sub-issues
description: GitHub Sub Issuesの作成・管理（追加/削除/一覧）を行うためのSkill。Use when Claude needs to: (1) Plan作成やタスク分解で関連するIssueを複数作り、親子関係を付けたい, (2) 既存の親Issueに子Issueを追加して進捗を追いたい, (3) 既存の親子関係を解除したい, (4) 親Issueに紐づくSub Issue一覧を取得したい
---

# GitHub Sub Issues

## Sub Issuesについて

GitHub Sub Issuesは、親Issueに対して子Issueを階層的に管理できる機能です。大きなタスクを小さな管理可能な単位に分割し、進捗状況を追跡できます。

## IDの種類

- REST APIの `id` は「IssueのID（integer, データベースID）」
- GraphQLの `node_id` は「IssueのID（GraphQL ID）」

Sub Issuesの追加/削除では、この2種類を取り違えないことが重要です。

## 前提条件

GitHub CLI (gh) がインストールされ、認証済みである必要があります。

```bash
gh auth login
```

## 基本情報の取得

リポジトリ情報を取得します。

```bash
OWNER_REPO=$(gh repo view --json nameWithOwner --jq '.nameWithOwner')
OWNER=$(echo $OWNER_REPO | cut -d'/' -f1)
REPO=$(echo $OWNER_REPO | cut -d'/' -f2)
```

## Sub Issueを追加

### REST APIで追加

REST APIは `sub_issue_id` として「IssueのID（データベースID）」を要求します。

```bash
PARENT_ISSUE_NUMBER=123
SUB_ISSUE_NUMBER=456

# sub_issue_id（integer）を取得
SUB_ISSUE_ID=$(gh api \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "repos/$OWNER_REPO/issues/$SUB_ISSUE_NUMBER" \
  --jq '.id')

# Sub Issueを追加（-F で integer として送る）
gh api \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  --method POST \
  "repos/$OWNER_REPO/issues/$PARENT_ISSUE_NUMBER/sub_issues" \
  -F sub_issue_id=$SUB_ISSUE_ID
```

### GraphQLで追加

GraphQLは `issueId`/`subIssueId` として「node_id（GraphQL ID）」を要求します。

```bash
PARENT_ISSUE_NUMBER=123
SUB_ISSUE_NUMBER=456

PARENT_NODE_ID=$(gh api "repos/$OWNER_REPO/issues/$PARENT_ISSUE_NUMBER" --jq '.node_id')
SUB_NODE_ID=$(gh api "repos/$OWNER_REPO/issues/$SUB_ISSUE_NUMBER" --jq '.node_id')

gh api graphql \
  -f query='
  mutation($issueId: ID!, $subIssueId: ID!) {
    addSubIssue(input: {issueId: $issueId, subIssueId: $subIssueId}) {
      subIssue { number title url }
    }
  }' \
  -f issueId="$PARENT_NODE_ID" \
  -f subIssueId="$SUB_NODE_ID"
```

## 親IssueのSub Issue一覧を取得

親Issueに紐づくSub Issueの一覧を取得します。

### REST APIで一覧取得

```bash
PARENT_ISSUE_NUMBER=123

gh api \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "repos/$OWNER_REPO/issues/$PARENT_ISSUE_NUMBER/sub_issues" \
  --jq '.[] | {id: .id, number: .number, title: .title, state: .state, html_url: .html_url}'
```

### GraphQLで一覧取得

```bash
PARENT_ISSUE_NUMBER=123

gh api graphql \
  --jq '.data.repository.issue.subIssues.nodes[] | {number: .number, title: .title, state: .state, url: .url}' \
  -f query='
  query($owner: String!, $repo: String!, $number: Int!) {
    repository(owner: $owner, name: $repo) {
      issue(number: $number) {
        subIssues(first: 20) {
          nodes {
            number
            title
            state
            url
          }
        }
      }
    }
  }' \
  -f owner="$OWNER" \
  -f repo="$REPO" \
  -F number=$PARENT_ISSUE_NUMBER
```

## Sub Issueの完了状況を取得

親Issueの進捗サマリを取得します（total/completed/%）。

```bash
PARENT_ISSUE_NUMBER=123

gh api \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "repos/$OWNER_REPO/issues/$PARENT_ISSUE_NUMBER" \
  --jq '.sub_issues_summary | {total: .total, completed: .completed, percent_completed: .percent_completed}'
```

## Sub Issueを親から削除

親IssueからSub Issueの関係を解除します（Issue自体は削除されません）。

```bash
PARENT_ISSUE_NUMBER=123
SUB_ISSUE_NUMBER=456

# sub_issue_id（integer）を取得
SUB_ISSUE_ID=$(gh api \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "repos/$OWNER_REPO/issues/$SUB_ISSUE_NUMBER" \
  --jq '.id')

# REST: 関係を解除
gh api \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  --method DELETE \
  "repos/$OWNER_REPO/issues/$PARENT_ISSUE_NUMBER/sub_issue" \
  -F sub_issue_id=$SUB_ISSUE_ID

# GraphQL: 関係を解除
PARENT_NODE_ID=$(gh api "repos/$OWNER_REPO/issues/$PARENT_ISSUE_NUMBER" --jq '.node_id')
SUB_NODE_ID=$(gh api "repos/$OWNER_REPO/issues/$SUB_ISSUE_NUMBER" --jq '.node_id')

gh api graphql \
  -f query='
  mutation($issueId: ID!, $subIssueId: ID!) {
    removeSubIssue(input: {issueId: $issueId, subIssueId: $subIssueId}) {
      subIssue {
        number
        title
      }
    }
  }' \
  -f issueId="$PARENT_NODE_ID" \
  -f subIssueId="$SUB_NODE_ID"
```

## 注意点

- REST APIは `sub_issue_id`（integer, IssueのID）を要求するため、`gh api` では `-F` を使って型を崩さないようにする
- GraphQL APIは `issueId`/`subIssueId`（ID, node_id）を要求する
- Sub Issueの作成にはWrite権限が必要です
- REST APIの追加では「sub-issueは親issueと同じリポジトリオーナー配下」である必要がある（例: 同一ユーザー/同一Organization配下）
