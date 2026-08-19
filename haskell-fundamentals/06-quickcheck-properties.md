# 6. QuickCheckで性質を書く

## 目的

具体例が「この入力ではこうなる」を表すのに対し、QuickCheckは多数の生成入力で成り立つ性質を検証します。例示ベースのTDDを置き換えるのではなく、具体例で理解した仕様を一般化するために使います。

## 最初のテスト

最初は `myReverse [1,2,3] == [3,2,1]` のようなHspecの具体例で始めます。実装が通った後、次の性質を追加します。

```haskell
property $ \xs -> myReverse (myReverse (xs :: [Int])) == xs
```

QuickCheckが反例を出した場合は、生成された入力を小さなHspecの再現ケースとして追加し、原因を絞ります。一般化できる修正をしてから、propertyを回帰テストとして残します。

## 完成実装

対象の完成実装は `src/HaskellTdd/Fundamentals.hs`、テストは `test/Spec.hs` の「QuickCheck properties」です。この教材では、reverseの往復性と、`findFirst` が返す値が必ず述語を満たす性質を確認します。

## リファクタリングの問い

全てをQuickCheckだけで表すと、学習者が最初の失敗を理解しにくくなる場合があります。境界値や読みやすい例はHspecに残し、入力全体に対する不変の関係をpropertyにします。

## 次に増やす振る舞い

第8章のTODOについて、タブや改行を含まないタイトルの生成器を作り、`parseTodos (renderTodos todos) == Right todos` の往復性をQuickCheckで検証してください。

## 実行

```bash
cabal test --offline --test-show-details=direct
```
