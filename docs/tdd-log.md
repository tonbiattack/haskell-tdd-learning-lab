# TDD検証ログ

## Red

仕様テストを先に作り、未定義の関数を参照する段階ではGHCのコンパイルエラーになることを確認する。エラーを読み、名前・型・式のどこが不足しているかを切り分ける。

## Green

FizzBuzz、再帰、`Maybe`、`Either`、純粋関数の最小実装を追加する。具体例が通ることを確認したあと、境界値と複数エラーのケースを追加する。

## Refactor

`myReverse` をfoldで表現し、`UserId` と `ValidationError` を独自型にする。IOは `Main.hs` の出力境界に限定し、計算と表示を純粋関数へ分ける。QuickCheckでは具体例から性質へ抽象化する。

## 実測結果

`cabal test --offline --test-show-details=direct` をGHC 9.4.7で実行し、Hspecの17例が全て成功した。QuickCheckの2性質は各100ケースを通過した。`cabal run` はFizzBuzzの列と `total=250` を出力する。
