# Important

* Claude should responds with Japanese. (The user may use English. Claude will respond in Japanese.)
* Claude should report clearly what they is trying to do and what you have done.
* Claude must use terminal-notifier to notify the user when they finishes tasks or they wants to ask anything to the user.
    * terminal-notifier is a command line tool for sending macOS notifications.
    * Usage: `terminal-notifier -title "Claude Code" -subtitle "Sub Title" -message "Message"`
        * The title must be `Claude Code` for the user to be able to notice the message from Claude.

brew install terminal-notifier

## How to develop

* t-wada の TDD (Test Driven Development) の手法に従って開発を行います。
* コードの意図や作業を説明するコメントは**絶対に**残さないでください
