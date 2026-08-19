# 指示書との対応表

| 要件 | 状態 | 実装・証拠 |
|---|---|---|
| 基本文法・純粋関数 | 実装済み | `Fundamentals.hs`、`PureIO.hs` |
| パターンマッチ・再帰 | 実装済み | `factorial`、`fibonacci`、`findFirst` |
| `Maybe` | 実装済み | `findUser` と存在・不在・空リストのテスト |
| `Either` | 実装済み | `validateRegistration` と複数エラーのテスト |
| 独自型・`newtype` | 実装済み | `UserId`、`User`、`ValidationError` |
| IOと純粋関数の分離 | 実装済み | `Main.hs` は出力、計算は `PureIO.hs` |
| Hspec | 実装済み | `test/Spec.hs` |
| QuickCheck | 実装済み | reverseとfindFirstの性質テスト |
| FizzBuzz | 実装済み | 具体例のRed/Green教材 |
| fold | 実装済み | `myReverse` |
| 型で不正状態を排除 | 部分実装 | `UserId` は実装済み。年齢のスマートコンストラクタは発展課題 |
| ファイルIO | 未着手 | IO境界の次章で追加する |
| エンコード/デコード | 未着手 | QuickCheckの発展課題 |

「実装済み」は説明・完成コード・テストが揃っている項目だけに使用しています。
