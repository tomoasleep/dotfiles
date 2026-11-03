# Important

* You should responds with Japanese. (The user may use English. You will respond in Japanese.)
* You should report clearly what they is trying to do and what you have done.
* You must use onotify to notify the user when they finishes tasks or they wants to ask anything to the user.
  * onotify is a command line tool for sending OS notifications (macOS: terminal-notifier, WSL2: Windows toast, other Linux: notify-send).
  * Usage: `onotify -title "OpenCode" -subtitle "Sub Title" -message "Message"`
    * The title must be `OpenCode` for the user to be able to notice the message from OpenCode.
* 計画の提出・確認と、ユーザーへの質問は Plannotator Inbox 経由で行ってください。
  * Inbox URL: `https://nemai-plannotator.drake-in.ts.net`
  * `plannotator_inbox` tool があればそれを、なければ stdio MCP (`plannotator inbox mcp`) を使う。
  * plan は `attachments` に添付し（保存先は `~/.local/share/opencode/plans/`）、判断が必要な箇所は `:::question` ブロックで質問する。返信はセッション idle 後に次のターンとして届く。
  * blocking なレビュー session（`plannotator annotate --gate` / `plannotator review`）は開かない。plan の承認も Inbox の返信で行う。
* 現在の作業に関連する Agent Skills を参照してください。 Agent Skills は積極的に参照してください。
  * コードの書き方などが Agent Skills に記載されている場合は、必ずそちらに従うこと。
* 技術調査やレポートの作成・提出には research-report Skill を参照してください。
  * 調査開始前の読者要件と解像度の確定を省略しないこと。提出前の4チェック(読者・独りよがり・鮮度・解像度)はサブエージェントによるレビューで実施すること。

## Development Style

* t-wada の TDD (Test Driven Development) の手法に従って開発を行います。
* コードの意図や作業を説明するコメントは、以下の場合を除いて追加しないでください
  * Linter などに要求された場合を除いて追加してはいけません
* ユーザーは冗長なコードや、不必要に防御的なコードを嫌います。
  * そういったコードは、書く前にユーザーに必要かを question tool で確認してください。
* stub, mock 等は、外部入出力を伴う箇所に対してのみ利用してください。それ以外では、ユーザーから明示的に指示がない場合使わないでください。

## Task Logging

* **進捗状況を vibedump Skill を使ってログに必ず記録してください。**
  * 例えば、ユーザーへの応答を開始、または完了したとき、タスクを開始したとき、タスクが完了したとき、タスクの途中で重要な決定をしたとき、ユーザーからの応答待ちになっている場合にログを記録してください。
* タスクの進捗なども vibedump を使って確認することが可能です。
