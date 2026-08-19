# 8. 純粋なTSV変換を保ったままファイルI/Oを扱う

## 目的

TODOの保存を題材に、文字列と値の変換を純粋関数へ残し、ファイルアクセスだけをIO境界に限定します。I/Oを一つの巨大な関数へ混ぜず、`renderTodos`、`parseTodos`、`saveTodos`、`loadTodos` の責務を分けます。

## 最初のテスト

まず、メモリ上の値をTSV文字列へ変換して戻せることをテストします。

```haskell
parseTodos (renderTodos todos) `shouldBe` Right todos
```

このGreenの後、不正IDや空タイトルをエラーにするテストを追加します。最後に一時ファイルを使い、保存して読み戻せる統合テストを足します。実際のファイルシステムを使うのは、純粋ロジックではなく外部境界が接続されることを確認するためです。

## 完成実装

完成コードは `src/HaskellTdd/TodoStore.hs`、テストは `test/Spec.hs` の「ファイルI/O境界」です。`TodoStoreError` は行形式、ID、タイトルのどこが不正かを型で表し、パース失敗を例外にせず `Either` で返します。

## リファクタリングの問い

TSVの分割と数値変換を `loadTodos` に埋め込むと、ファイルなしのテストが難しくなります。純粋な `parseTodos` へ取り出すと、正常入力・壊れた行・境界値をHspecで高速に検証でき、I/Oテストは一つの往復確認へ絞れます。

## 次に増やす振る舞い

タイトルへタブや改行を許可するかを決め、許可する場合はTSVではなくJSONなど、表現力のある形式へ変更してください。変更前に往復性と不正入力のテストを増やします。

## 実行

```bash
cabal test --offline --test-show-details=direct
```
