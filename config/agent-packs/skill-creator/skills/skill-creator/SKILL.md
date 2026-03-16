---
name: skill-creator
description: "Guide for creating new Skills. Use when: (1) Creating a new skill to extend Claude's capabilities, (2) Improving existing skills, (3) Understanding skill structure and best practices"
---

# Skill Creator

## 概要

このSkillは、Claudeの能力を拡張する新しいSkillを作成するためのガイドです。

Skillは、専門的な知識、ワークフロー、ツール統合を提供することでClaudeの機能を拡張する、モジュール式の自己完結型パッケージです。特定のドメインやタスクのための「オンボーディングガイド」として機能します。

### Skillが提供するもの

1. 専門的なワークフロー - 特定のドメイン向けの多ステップ手続き
2. ツール統合 - 特定のファイル形式やAPIの操作手順
3. ドメインの専門知識 - 会社固有の知識、スキーマ、ビジネスロジック
4. バンドルされたリソース - スクリプト、リファレンス、複雑なタスク向けのアセット

## Core Principles

### Concise is Key

コンテキストウィンドウは共有リソースです。Skillはシステムプロンプト、会話履歴、他のSkillのメタデータ、実際のユーザーリクエストと共有されます。

**デフォルトの前提: Claudeはすでに非常にスマートです。** Claudeがまだ持っていない情報だけを追加してください。各情報に「Claudeは本当にこの説明が必要か？」と「このパラグラフはそのトークンコストに見合うか？」と問いかけてください。

冗長な説明よりも簡潔な例を好んでください。

### Set Appropriate Degrees of Freedom

タスクの壊れやすさと変動性に応じて、特異性のレベルを合わせてください：

**高自由度（テキストベースの指示）**: 複数のアプローチが有効、文脈に依存する決定、ヒューリスティックがアプローチを導く場合に使用します。

**中自由度（パラメータ付き疑似コードまたはスクリプト）**: 好ましいパターンが存在、ある程度の変動が許容可能、設定が動作に影響する場合に使用します。

**低自由度（特定のスクリプト、少数のパラメータ）**: 操作が壊れやすくエラーが発生しやすい、一貫性が重要、特定のシーケンスに従う必要がある場合に使用します。

Claudeをパスを探索する旅人と考えてください：崖のある狭い橋には特定の手すり（低自由度）が必要ですが、開けた野原では多くのルートが可能です（高自由度）。

### Anatomy of a Skill

すべてのSkillは必須のSKILL.mdファイルとオプションのバンドルされたリソースで構成されます：

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter metadata (required)
│   │   ├── name: (required)
│   │   └── description: (required)
│   └── Markdown instructions (required)
└── Bundled Resources (optional)
    ├── scripts/          - Executable code (Ruby/Bash/etc.)
    ├── references/       - Documentation loaded as needed
    └── assets/           - Files used in output (templates, icons, fonts)
```

#### SKILL.md (required)

すべてのSKILL.mdは以下で構成されます：

- **Frontmatter** (YAML): `name`と`description`フィールドが含まれます。これらはClaudeがいつSkillを使用するかを判断するために読み取る唯一のフィールドであるため、Skillが何であり、いつ使用すべきかを明確かつ包括的に記述することが非常に重要です。
- **Body** (Markdown): Skillを使用するための指示とガイダンス。Skillがトリガーされた後にのみ読み込まれます。

#### Bundled Resources (optional)

##### Scripts (`scripts/`)

決定論的な信頼性が必要または繰り返し書き直されるタスク用の実行可能コード（Ruby/Bashなど）。

- **含めるタイミング**: 同じコードが繰り返し書き直されている、または決定論的な信頼性が必要な場合
- **例**: PDF回転タスク用の`scripts/rotate_pdf.rb`
- **利点**: トークン効率が良い、決定論的、コンテキストに読み込まずに実行可能
- **注**: パッチ適用や環境固有の調整のために、Claudeがスクリプトを読み込む必要がある場合があります

##### References (`references/`)

Claudeのプロセスと思考を通知するために、必要に応じてコンテキストに読み込まれることを意図したドキュメントと参照資料。

- **含めるタイミング**: Claudeが作業中に参照すべきドキュメント用
- **例**: 財務スキーマ用の`references/finance.md`、会社NDAテンプレート用の`references/mnda.md`、会社ポリシー用の`references/policies.md`、API仕様用の`references/api_docs.md`
- **使用例**: データベーススキーマ、APIドキュメント、ドメイン知識、会社ポリシー、詳細なワークフローガイド
- **利点**: SKILL.mdをリーンに保つ、Claudeが必要と判断したときにのみ読み込まれる
- **ベストプラクティス**: ファイルが大きい（10k語を超える）場合、SKILL.mdにgrep検索パターンを含めます
- **重複を避ける**: 情報はSKILL.mdまたは参照ファイルのいずれかに存在し、両方には存在しません。詳細な参照資料、スキーマ、例には参照ファイルを好みますが、Skillに本当に不可欠な情報はSKILL.mdに保持します。これにより、SKILL.mdをリーンに保ちながら、情報を発見可能にし、コンテキストウィンドウを占有しません。

##### Assets (`assets/`)

コンテキストに読み込まれるのではなく、Claudeが生成する出力内で使用されることを意図したファイル。

- **含めるタイミング**: Skillが最終出力で使用するファイルが必要な場合
- **例**: ブランドアセット用の`assets/logo.png`、PowerPointテンプレート用の`assets/slides.pptx`、HTML/React boilerplate用の`assets/frontend-template/`、タイポグラフィ用の`assets/font.ttf`
- **使用例**: テンプレート、画像、アイコン、boilerplateコード、フォント、コピーまたは変更されるサンプルドキュメント
- **利点**: 出力リソースをドキュメントから分離、コンテキストに読み込まずにファイルを使用可能

#### Skillに含めないもの

Skillは、その機能を直接サポートする必須ファイルのみを含むべきです。余計なドキュメントや補助ファイルを作成しないでください：

- README.md
- INSTALLATION_GUIDE.md
- QUICK_REFERENCE.md
- CHANGELOG.md
- など

Skillは、AIエージェントがその場の仕事をするために必要な情報のみを含むべきです。その作成プロセス、セットアップとテスト手順、ユーザー向けドキュメントなどに関する補助的なコンテキストを含めるべきではありません。追加のドキュメントファイルを作成するだけでは、雑然と混乱を招くだけです。

### Progressive Disclosure Design Principle

Skillは、コンテキストを効率的に管理するための3レベルのローディングシステムを使用します：

1. **Metadata (name + description)** - 常にコンテキスト内（約100語）
2. **SKILL.md body** - Skillがトリガーされたとき（5k語未満）
3. **Bundled resources** - Claudeが必要に応じて（スクリプトはコンテキストウィンドウに読み込まずに実行できるため無制限）

#### Progressive Disclosure Patterns

SKILL.mdのボディを必須事項と500行未満に保ち、コンテキストの肥大化を最小限に抑えます。この制限に近づいたら、コンテンツを別のファイルに分割してください。コンテンツを他のファイルに分割する際、SKILL.mdからそれらを参照し、いつ読むべきかを明確に説明することが非常に重要です。これにより、Skillの読者がそれらが存在することと、いつ使用するかを知ることができます。

**重要な原則:** Skillが複数のバリエーション、フレームワーク、オプションをサポートする場合、SKILL.mdにはコアワークフローと選択ガイダンスのみを保持します。バリエーション固有の詳細（パターン、例、設定）は別の参照ファイルに移動します。

**Pattern 1: 高レベルガイドと参照**

```markdown
# PDF Processing

## Quick start

pdfplumberでテキストを抽出：
[code example]

## Advanced features

- **Form filling**: 完全なガイドは[FORMS.md](FORMS.md)を参照
- **API reference**: すべてのメソッドは[REFERENCE.md](REFERENCE.md)を参照
- **Examples**: 一般的なパターンは[EXAMPLES.md](EXAMPLES.md)を参照
```

Claudeは必要なときにのみFORMS.md、REFERENCE.md、またはEXAMPLES.mdを読み込みます。

**Pattern 2: ドメイン固有の組織**

複数のドメインを持つSkillでは、無関係なコンテキストを読み込むのを避けるために、ドメインごとにコンテンツを整理します：

```
bigquery-skill/
├── SKILL.md (overview and navigation)
└── reference/
    ├── finance.md (revenue, billing metrics)
    ├── sales.md (opportunities, pipeline)
    ├── product.md (API usage, features)
    └── marketing.md (campaigns, attribution)
```

ユーザーが売上指標について尋ねたとき、Claudeはsales.mdのみを読み込みます。

同様に、複数のフレームワークやバリエーションをサポートするSkillでは、バリエーションごとに整理します：

```
cloud-deploy/
├── SKILL.md (workflow + provider selection)
└── references/
    ├── aws.md (AWS deployment patterns)
    ├── gcp.md (GCP deployment patterns)
    └── azure.md (Azure deployment patterns)
```

ユーザーがAWSを選択したとき、Claudeはaws.mdのみを読み込みます。

**Pattern 3: 条件付き詳細**

基本的なコンテンツを表示し、詳細なコンテンツにリンクします：

```markdown
# DOCX Processing

## Creating documents

新しいドキュメントにはdocx-jsを使用。[DOCX-JS.md](DOCX-JS.md)を参照。

## Editing documents

単純な編集では、XMLを直接変更します。

**For tracked changes**: [REDLINING.md](REDLINING.md)を参照
**For OOXML details**: [OOXML.md](OOXML.md)を参照
```

Claudeは、ユーザーがそれらの機能を必要とするときにのみ、REDLINING.mdまたはOOXML.mdを読み込みます。

**重要なガイドライン:**

- **深くネストされた参照を避ける** - 参照はSKILL.mdから1レベル深くに保ちます。すべての参照ファイルはSKILL.mdから直接リンクする必要があります。
- **長い参照ファイルを構造化する** - 100行を超えるファイルには、プレビュー時にClaudeが完全な範囲を確認できるように、上部に目次を含めます。

## Skill作成プロセス

Skillの作成には以下の手順が含まれます：

1. 具体的な例でSkillを理解する
2. 再利用可能なSkillのコンテンツを計画する
3. Skillを初期化する（init_skill.rbを実行）
4. Skillを編集する（リソースを実装しSKILL.mdを書く）
5. Skillを検証する（validate_skill.rbを実行）
6. 実際の使用に基づいて反復する

これらの手順を順に従い、適用されない明確な理由がある場合のみスキップしてください。

### Step 1: 具体的な例でSkillを理解する

Skillの使用パターンが既に明確に理解されている場合のみ、この手順をスキップします。既存のSkillを操作する場合でも、この手順は価値があります。

効果的なSkillを作成するには、Skillがどのように使用されるかを具体的な例で明確に理解する必要があります。この理解は、直接のユーザー例またはユーザーフィードバックで検証された生成例から得ることができます。

例えば、`image-editor` Skillを作成する場合、関連する質問には以下が含まれます：

- "image-editor Skillはどのような機能をサポートすべき？編集、回転、それ以外？"
- "このSkillがどのように使用されるかの例を教えてもらえますか？"
- "ユーザーは'この画像の赤目を消して'や'この画像を回転して'と言うのを想像できます。他にこのSkillがどのように使用されることを想像できますか？"
- "ユーザーが何と言うとこのSkillがトリガーされるべきでしょうか？"

ユーザーを圧倒しないように、1つのメッセージで多くの質問をしないでください。最も重要な質問から始め、より良い効果のために必要に応じてフォローアップしてください。

Skillがサポートすべき機能の明確な感覚があるときに、この手順を終了します。

### Step 2: 再利用可能なSkillコンテンツを計画する

具体的な例を効果的なSkillに変換するには、各例を以下のように分析します：

1. 最初から例を実行する方法を検討する
2. これらのワークフローを繰り返し実行するときに役立つスクリプト、参照、アセットを特定する

例：`pdf-editor` Skillを構築して、「このPDFを回転してください」というクエリを処理する場合、分析は以下を示します：

1. PDFを回転するには、毎回同じコードを書き直す必要がある
2. `scripts/rotate_pdf.rb`スクリプトをSkillに保存すると役立つ

例：`frontend-webapp-builder` Skillを設計して、「todoアプリを構築して」や「歩数を追跡するダッシュボードを構築して」というクエリを処理する場合、分析は以下を示します：

1. フロントエンドWebアプリを構築するには、毎回同じboilerplate HTML/Reactが必要
2. `assets/hello-world/`テンプレートにboilerplate HTML/Reactプロジェクトファイルを含むと役立つ

例：`big-query` Skillを構築して、「今日何人のユーザーがログインしましたか？」というクエリを処理する場合、分析は以下を示します：

1. BigQueryにクエリするには、テーブルスキーマと関係を毎回再発見する必要がある
2. `references/schema.md`ファイルにテーブルスキーマを文書化すると役立つ

Skillのコンテンツを確立するには、各具体的な例を分析して、含める再利用可能なリソースのリストを作成します：スクリプト、参照、アセット。

この手順では、Question Toolを使用してユーザーに以下を確認します：

1. Skillの主な使用例は何ですか？
2. スクリプト（Ruby/Bashなど）を含める必要がありますか？
3. リファレンスドキュメントを含める必要がありますか？
4. アセット（テンプレート、画像など）を含める必要がありますか？

### Step 3: Skillを初期化する

**Rubyスクリプトを使用した初期化:**

```bash
cd /Users/tomoya/.ghq/github.com/tomoasleep/dotfiles/config/.claude/skills/skill-creator/scripts
ruby init_skill.rb <skill-name>
```

このスクリプトは以下を作成します：

- `config/.claude/skills/<skill-name>/` ディレクトリ
- `<skill-name>/SKILL.md` テンプレート
- `<skill-name>/scripts/` ディレクトリ
- `<skill-name>/references/` ディレクトリ
- `<skill-name>/assets/` ディレクトリ

例：

```bash
ruby init_skill.rb pdf-editor
```

### Step 4: Skillを編集する

**SKILL.mdを記述:**

1. **Frontmatter**を記述する：
   - `name`: Skillの名前（ディレクトリ名と一致させる必要があります）
   - `description`: Skillが何をするか、いつ使用すべきかを包括的に記述します

2. **Body**を記述する：
   - **概要**: Skillの目的と機能
   - **手順**: このSkillを使用するためのステップバイステップガイド
   - **例**: Skillがどのように使用されるかを示す具体的な例

**重要なガイドライン:**

- **簡潔さ**: Claudeがすでに知っている情報を繰り返さないでください
- **具体性**: 抽象的な概念よりも具体的な例を好む
- **一貫性**: 既存のSkillと同じ構造とスタイルを維持する

**リソースを実装:**

- **Scripts**: 決定論的な信頼性が必要なコードを`scripts/`に追加（Ruby、Bashなど）
- **References**: ドキュメントと参照資料を`references/`に追加
- **Assets**: テンプレート、画像などを出力に使用するファイルを`assets/`に追加

### Step 5: Skillを検証する

**Rubyスクリプトを使用した検証:**

```bash
cd /Users/tomoya/.ghq/github.com/tomoasleep/dotfiles/config/.claude/skills/skill-creator/scripts
ruby validate_skill.rb <skill-path>
```

このスクリプトは以下を検証します：

- ディレクトリ構造が正しい
- `SKILL.md`が存在する
- Frontmatterに`name`と`description`が含まれている
- Frontmatterの`name`がディレクトリ名と一致する
- `description`が十分に記述されている

例：

```bash
ruby validate_skill.rb ../../pdf-editor
```

### Step 6: 実際の使用に基づいて反復する

Skillを作成した後、実際の使用状況に基づいて改善を続けてください。

ユーザーフィードバックを収集し、以下を確認します：

- Skillが期待通り機能しているか？
- 不明瞭または冗長な指示があるか？
- 追加の例が必要か？
- 検証に失敗するエッジケースがあるか？

**注意事項:**

- **TDDの適用**: t-wadaのTDD（Test Driven Development）の手法に従って開発を行うことを推奨します
- **コードの品質**: コードの意図や作業を説明するコメントは残さないでください（CLAUDE.mdの方針に従う）
- **日本語でのコミュニケーション**: ユーザーとのコミュニケーションは日本語で行ってください
- **terminal-notifierの使用**: タスク完了時やユーザーに質問があるときは、terminal-notifierで通知してください

## Rubyスクリプト使用方法

### init_skill.rb

新しいSkillのディレクトリ構造を初期化します。

**使用方法:**

```bash
cd /Users/tomoya/.ghq/github.com/tomoasleep/dotfiles/config/.claude/skills/skill-creator/scripts
ruby init_skill.rb <skill-name>
```

**機能:**

- `config/.claude/skills/<skill-name>/` ディレクトリの作成
- `SKILL.md`テンプレートの生成
- `scripts/`, `references/`, `assets/` ディレクトリの作成

**バリデーション:**

- Skill名は小文字、数字、ハイフンのみ使用可能（例：`my-skill`）
- 既存のディレクトリ名と重複しないことを確認

### validate_skill.rb

Skillの構造とコンテンツを検証します。

**使用方法:**

```bash
cd /Users/tomoya/.ghq/github.com/tomoasleep/dotfiles/config/.claude/skills/skill-creator/scripts
ruby validate_skill.rb <skill-path>
```

**機能:**

- ディレクトリ構造の検証
- `SKILL.md`の存在確認
- Frontmatterの`name`と`description`の存在確認
- Frontmatterの`name`とディレクトリ名の一致確認
- `description`の品質チェック

## 対話的なSkill作成プロセス

ユーザーが新しいSkillの作成をリクエストしたら、Question Toolを使用して以下の質問を対話的に進めてください：

### Phase 1: Skillの目的を理解する

1. **Skillの名前**: 作成したいSkillの名前は何ですか？（ハイフン区切り、小文字）
2. **主な目的**: このSkillは何をするためのものですか？
3. **使用例**: 具体的な使用例を教えてください
4. **トリガー条件**: どのようなリクエストがこのSkillをトリガーすべきですか？

### Phase 2: コンテンツを計画する

5. **スクリプト**: 決定論的な実行が必要なコードを含める必要がありますか？
6. **参照資料**: ドキュメントやスキーマを含める必要がありますか？
7. **アセット**: テンプレートや画像を含める必要がありますか？

### Phase 3: 初期化と実装

8. 初期化の確認: `init_skill.rb`を実行してディレクトリ構造を作成しますか？
9. SKILL.mdの記述: FrontmatterとBodyの内容を確認します

### Phase 4: 検証とフィードバック

10. 検証の確認: `validate_skill.rb`を実行してSkillを検証しますか？

完了したら、`terminal-notifier`を使用してユーザーに通知してください。
