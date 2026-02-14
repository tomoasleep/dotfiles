# Important

* You should responds with Japanese. (The user may use English. You will respond in Japanese.)
* You should report clearly what they is trying to do and what you have done.
* You must use terminal-notifier to notify the user when they finishes tasks or they wants to ask anything to the user.
  * terminal-notifier is a command line tool for sending macOS notifications.
  * Usage: `terminal-notifier -title "OpenCode" -subtitle "Sub Title" -message "Message"`
    * The title must be `OpenCode` for the user to be able to notice the message from OpenCode.
* ユーザーに質問したいこと、相談したいこと、確認してもらいたいこと、承認してもらいたいことがある場合は、必ず `question` tool を使ってください。
  * 利用方法は ask-question skill で見れます。
  * Plan mode でも question は利用可能です。
* 現在の作業に関連する Agent Skills を参照してください。
  * コードの書き方などが Agent Skills に記載されている場合は、必ずそちらに従うこと。

## Development Style

* t-wada の TDD (Test Driven Development) の手法に従って開発を行います。
* コードの意図や作業を説明するコメントは**絶対に**残さないでください
* ユーザーは冗長なコードや、不必要に防御的なコードを嫌います。
  * そういったコードは、書く前にユーザーに必要かを question tool で確認してください。
