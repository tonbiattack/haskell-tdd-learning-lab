# 設計判断

## 教材の置換方針

この教材は、オブジェクト指向言語のTDD教材にある「値オブジェクト、不変条件、依存の差し替え、ファイルI/O、Web境界」といった設計上の問いを、Haskellの慣用へ置き換えます。原典のAPIやクラス構成を機械的に翻訳しません。置換の根拠と参照した既存TDD教材は `docs/research-notes.md` に記録しています。

| 設計上の問い | Haskellでの選択 | この教材での実装 |
|---|---|---|
| 値を区別する | `newtype` と抽象型 | `UserId`、`UserName`、`Age` |
| 期待される失敗を返す | `Maybe` または `Either` | `findUser`、`validateRegistration`、`parseTodos` |
| 不変条件を保つ | スマートコンストラクタ | `mkUserName`、`mkAge`、`mkValidRegistration` |
| 依存をテストで差し替える | 小さな関数引数 | `Writer` と `runReport` |
| 外部境界を隔離する | 純粋変換 + 薄いIO関数 | `renderTodos`、`parseTodos`、`saveTodos`、`loadTodos` |
| 多数の入力を検査する | QuickCheck property | reverseの往復性、`findFirst` の返却条件 |

## 純粋関数とIO

外部境界を除くロジックは純粋関数に置き、テストの入力と出力を明示します。`app/Main.hs` は表示の起点であり、計算は `HaskellTdd.PureIO` に切り出します。TODO保存でも、TSV文字列への変換と文字列からの復元は純粋に保ち、ファイル読書きだけをIOに置きます。これにより、ほとんどの失敗をファイルや端末なしでHspecへ閉じ込められます。

## 不在・検証失敗・不変条件

`findUser` は見つからない状態を `Maybe User` で表します。`validateRegistration` はフォーム入力のエラーを収集する教材として `Either [ValidationError] Registration` を返します。第7章の `SafeRegistration` はもう一段進め、空の名前と範囲外の年齢を `UserName` と `Age` として構築しないようにします。

> `Either` は「不正な入力を受け取った時点で、その理由を返す」ために使い、スマートコンストラクタは「検証済みの値を後続へ渡す」ために使う。二つは競合せず、境界とドメインの責務を分ける。

## 依存の差し替え

`runReport` は `String -> IO ()` を受け取ります。出力先をテストで差し替えられるため、標準出力を捕捉せず `IORef` の手書きスパイで呼出結果を確認できます。依存が一つの関数で足りる間は、型クラスや大型モックフレームワークを導入しません。

## 今後の設計課題

TSVではタブや改行を含むタイトルを安全に表現できないため、仕様を拡張する場合はエスケープ規則かJSON形式を選びます。HTTP、非同期処理、永続化を追加するときも、まず純粋なドメイン関数をテストし、次に外部境界を最小の統合テストで確認します。
