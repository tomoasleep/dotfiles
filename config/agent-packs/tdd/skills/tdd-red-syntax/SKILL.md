---
name: tdd-red-syntax
description: |
  TDD の Red Phase で failing test を書くための構文ガイド。RSpec、Jest、Vitest、Bun test、Minitest など各フレームワークでの xit、skip、pending、test.failing の使い方と使い分けを解説。新機能実装時やバグ修正時に「これから実装するテスト」をどうマークするかが不明な場合に使用。CI 環境での扱いや Todo 実装パターンについてもカバー。
---

# TDD Red Phase Syntax

## 概要

TDD の Red Phase では、実装前に失敗するテストを書きます。「これから実装する機能」に対するテストは、通常のテストランナーでは即座に失敗します。フレームワークごとに用意された構文を使って、この意図的な失敗を明示的にマークします。

## 構文一覧

### RSpec (Ruby)

```ruby
xit 'returns the total price' do
  expect(cart.total).to eq(100)
end

it 'calculates tax' do
  pending('tax calculation not implemented')
  expect(cart.tax).to eq(10)
end

skip 'international shipping' if ENV['CI']
```

**使い分け:**
- `xit`: テスト本体ごとスキップ。実装前。
- `pending`: 実装中。失敗を期待し、緑になったら警告。
- `skip`: 一時的なスキップ。後で戻る意图。

### Jest / Vitest (JavaScript/TypeScript)

```typescript
xit('creates a new user', () => {
  expect(createUser('test@example.com')).toBeDefined()
})

xdescribe('PaymentProcessor', () => {
  it('processes payment', () => {})
  it('handles refund', () => {})
})

test.skip('feature not implemented', () => {})

test.failing('throws on invalid input', () => {
  expect(() => parse('invalid')).toThrow()
})
```

**使い分け:**
- `xit`, `xdescribe`: 実装前。テスト全体をスキップ。
- `test.skip`: 一時的なスキップ。
- `test.failing`: 実装中。失敗を期待し、緑になったら失敗（バグ修正の検出）。

### Bun test

```typescript
import { test, describe } from 'bun:test'

test.skip('upcoming feature', () => {})

test.failing('validates email format', () => {
  expect(validateEmail('invalid')).toBe(false)
})
```

**特徴:**
- `test.failing` は緑になると失敗する。バグ修正や期待した失敗の検出に使う。

### Minitest (Ruby)

```ruby
def test_upcoming_feature
  skip('not implemented yet')
  assert_equal 42, calculate_answer
end

def test_complex_calculation
  omit if ENV['CI']
end
```

**使い分け:**
- `skip`: 実装前。理由を記載。
- `omit`: CI ではスキップ。

## 実践パターン

### 1. 新機能実装の Todo リスト

```ruby
describe 'ShoppingCart' do
  xit 'calculates total with tax'
  xit 'applies discount codes'
  xit 'handles empty cart'
end
```

```typescript
describe('ShoppingCart', () => {
  xit('calculates total with tax', () => {})
  xit('applies discount codes', () => {})
  xit('handles empty cart', () => {})
})
```

Todo リストとして xit を並べ、実装ごとに `x` を外していく。

### 2. バグ修正前の再現テスト

```typescript
test.failing('handles null user gracefully', () => {
  expect(getUserDisplayName(null)).toBe('Anonymous')
})
```

バグがある間はテストが pass し（fail を期待しているので）、修正後はテストが fail する（期待していた失敗が発生しなくなった）。これで「修正し忘れ」を防ぐ。

### 3. CI での扱い

多くのフレームワークは `xit`, `skip`, `pending` をスキップ扱いにする。CI では:

```yaml
- name: Run tests
  run: npm test
- name: Check for skipped tests
  run: |
    if grep -r "xit\|test.skip\|pending" test/ --include="*.test.ts"; then
      echo "Found skipped tests. Review before merge."
      exit 1
    fi
```

### 4. 段階的な実装 (Growing Object-Oriented Software)

```ruby
xit 'calculates shipping cost' do
  expect(cart.shipping).to eq(5)
end

it 'calculates shipping cost' do
  pending('implementation in progress')
  expect(cart.shipping).to eq(5)
end

it 'calculates shipping cost' do
  expect(cart.shipping).to eq(5)
end
```

`xit` → `pending` → 通常のテスト、と段階的に進める。

## 注意点

### xit を残したままマージしない

`xit` は「未実装」のマーク。マージ前に必ず通常のテストに変更する。`grep` や CI でチェック。

### test.failing の使いすぎに注意

`test.failing` は「今は失敗するが、修正後は成功する」テストに使う。安易な失敗テストの隠蓑に使わない。

### pending と xit の違い

- `xit`: テスト全体をスキップ。実行されない。
- `pending`: 実行されるが、失敗を期待。成功すると警告。

フレームワークごとに挙動が異なるため、ドキュメントを確認。

## フレームワーク別クイックリファレンス

| Framework | Skip | Pending | Failing |
|-----------|------|---------|---------|
| RSpec | `xit`, `skip` | `pending` | N/A |
| Jest | `xit`, `test.skip` | N/A | N/A |
| Vitest | `xit`, `test.skip` | N/A | `test.failing` |
| Bun | `test.skip` | N/A | `test.failing` |
| Minitest | `skip` | `omit` | N/A |

## 推奨ワークフロー

1. **Red Phase**: `xit` でテストを書く
2. **実装開始**: `xit` を `it` に変更（または `pending` に変更して実行）
3. **Green Phase**: テストが pass するまで実装
4. **Refactor Phase**: コードを整理
5. **マージ前**: `xit`, `skip`, `pending` が残っていないか確認

## この Skill が役立つ場面

- 「テストを先に書きたいが、どうマークすればいい？」
- 「xit と pending の違いは？」
- 「test.failing はどう使う？」
- 「CI で xit を検出したい」

これらの疑問に対して、フレームワーク別の構文とベストプラクティスを提供する。