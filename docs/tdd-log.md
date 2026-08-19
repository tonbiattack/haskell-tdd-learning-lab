# TDD検証ログ

## Red

各章では、未定義の関数を呼ぶ最初のテスト、または意図した振る舞いとの差分から始める。未定義の名前や型不一致は、GHCが次に必要な関数・入力・出力を示すRedの観測として扱う。第7章では空名の拒否、第8章ではTODOの往復変換、第9章では注入した出力関数の呼出を、最初の小さな仕様にする。

## Green

FizzBuzz、再帰、`Maybe`、`Either`、純粋関数、スマートコンストラクタ、TSV変換、依存を受け取るレポート関数を、一つずつテストが通る最小実装で追加する。ファイルI/Oは、先に純粋な`renderTodos`と`parseTodos`をGreenにしてから、`saveTodos`と`loadTodos`の一時ファイル統合テストを加える。

## Refactor

`myReverse` をfoldで表現し、`UserId`、`UserName`、`Age`、各種エラーを独自型にする。IOは `Main.hs`、`TodoStore`、`Report` の薄い境界に限定し、計算と文字列変換は純粋関数へ分ける。出力先は `Writer` 関数で受け取り、テストでは `IORef` の手書きスパイへ差し替える。QuickCheckでは具体例から性質へ抽象化する。

## 実測結果

GHC 9.4.7で `cabal test --offline --test-show-details=direct` を実行し、Hspecの29例がすべて成功した。QuickCheckの2性質は各100ケースを通過し、コンパイル警告はなかった。`scripts/verify-doc-links.sh` はMarkdownのローカルリンクをすべて解決した。詳細は `docs/verification.md` を参照する。
