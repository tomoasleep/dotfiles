---
name: self-review
description: Check if current changes meets the quality standards and satisfy the given code review comments (if already given).
---

# self-review

あなたが行うことは、現状の変更が品質基準を満たしているか、また、既に与えられたコードレビューコメントがある場合、それらを満たしているかを確認することです。
コードの修正は行いません。必要に応じて、追加の修正タスクを提案してください。

## TODO

1. Git の差分の検証
2. 以下のそれぞれのチェックを行い、ユーザーに問題を報告します。
    - 品質基準チェック
    - コードレビューチェック

### Git の差分の検証

`gh pr view` などを用い、現状の変更のベースブランチを確認し、比較します。(対応する Pull Request がなければベースブランチは master とします。)

### 品質基準チェック

1. Tool Checklist に記載された各種ツールから、今回の変更に関連があるツールを選択し、それぞれ実行します
2. コーディング規約を確認し、それに準拠していることを確認します
    - URL: https://qiita-inc.qiita.com/shared/items/1d91ce2467a9948c85df (Qiita Team 内のため、 Qiita Team MCP の利用が必須です。)

#### Tool Checklist

- Linting
  - Run `bundle exec rubocop` and fix any offenses
  - Run `yarn lint` and fix any issues
- Run tests
  - Run `bundle exec rspec TEST_FILES` to ensure that related tests passes
  - Run `yarn test` and ensure all tests pass
- Others
  - Looks up `lint-staged` section in package.json and run the listed commands

### コードレビューチェック

#### 進め方の手順

1. 次項の記載のコマンドを用いて、Resolveしていないレビューコメントを確認する
2. Resolveしていないレビューコメントの内容を理解する
3. 現状の差分と比較し、指摘が解消されているかを確認する。
4. 再度 gh コマンドを実行し、未対応かつ Resolve していないレビューコメントが無いかを確認する。あれば2に戻り、なければ完了

#### ghコマンド

以下のコマンドでResolveしていないレビューコメントを取得できます。

```bash
OWNER_REPO=$(gh repo view --json nameWithOwner --jq '.nameWithOwner')
OWNER=$(echo $OWNER_REPO | cut -d'/' -f1)
REPO=$(echo $OWNER_REPO | cut -d'/' -f2)
PR_NUMBER=$(gh pr view --json number --jq '.number')

gh api graphql -f query="
query {
  repository(owner: \"${OWNER}\", name: \"${REPO}\") {
    pullRequest(number: ${PR_NUMBER}) {
      number
      title
      url
      state
      author {
        login
      }
      reviewRequests(first: 20) {
        nodes {
          requestedReviewer {
            ... on User {
              login
            }
          }
        }
      }
      reviewThreads(last: 20) {
        edges {
          node {
            isResolved
            isOutdated
            path
            line
            comments(last: 20) {
              nodes {
                author {
                  login
                }
                body
                url
                createdAt
              }
            }
          }
        }
      }
    }
  }
}" --jq '
  .data.repository.pullRequest as $pr |
  {
    pr_number: $pr.number,
    title: $pr.title,
    url: $pr.url,
    state: $pr.state,
    author: $pr.author.login,
    requested_reviewers: [.data.repository.pullRequest.reviewRequests.nodes[].requestedReviewer.login],
    unresolved_threads: [
      $pr.reviewThreads.edges[] |
      select(.node.isResolved == false) |
      {
        path: .node.path,
        line: .node.line,
        is_outdated: .node.isOutdated,
        comments: [
          .node.comments.nodes[] |
          {
            author: .author.login,
            body: .body,
            url: .url,
            created_at: .createdAt
          }
        ]
      }
    ]
  }
'
```
