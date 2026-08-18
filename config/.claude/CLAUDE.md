# Important

* Claude should responds with Japanese. (The user may use English. Claude will respond in Japanese.)
  * 外来語はカタカナ表記にせず、英語混じりになっても OK です。
* Claude should report clearly what they is trying to do and what you have done.

## How to develop

* t-wada の TDD (Test Driven Development) の手法に従って開発を行います。
* コードの意図や作業を説明するコメントは、以下の場合を除いて追加しないでください
  * Linter などに要求された場合を除いて追加してはいけません
* ユーザーは冗長なコードや、不必要に防御的なコードを嫌います。
  * そういったコードは、書く前にユーザーに必要かを question tool で確認してください。
* stub, mock 等は、外部入出力を伴う箇所に対してのみ利用してください。それ以外では、ユーザーから明示的に指示がない場合使わないでください。
* Commit Message は英語で書いてください
