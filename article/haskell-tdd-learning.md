# HaskellをTDDで学ぶ：具体例からMaybe・Either・QuickCheckへ進む小さなラボ

## はじめに

Haskellの学習を構文の暗記で終わらせず、テストを仕様として扱いながら、純粋関数と型による設計へ進む教材を作りました。この記事では、添付の学習方針を一つの実行可能なCabalプロジェクトへ落とし込み、Red → Green → Refactorの流れを、FizzBuzz、`Maybe`、`Either`、IO分離、QuickCheckで確認します。

このラボはGHC 9.4.7、Cabal 3.8.1.0、Hspec、QuickCheckで検証しました。GHCはコンパイルとGHCiを提供する実装環境であり、公式ユーザーガイドにはGHCi、コンパイル、警告設定などの章があります。[1] Hspecはテスト記述用のDSLとQuickCheck連携を備えています。[2]

## 今回の仕様

学ぶ順番を次のように固定しました。

| 段階 | 仕様 | 主要な問い |
|---|---|---|
| 基礎 | 数値をFizz、Buzz、FizzBuzzへ変換する | ガードの順番と純粋関数とは何か |
| 再帰 | 階乗、Fibonacci、reverse、検索を実装する | 空リストと再帰の基底ケースをどう表すか |
| `Maybe` | IDでユーザーを検索する | 見つからない状態を例外なしでどう表現するか |
| `Either` | 登録情報を検証する | エラーを型として、複数件まとめてどう返すか |
| IO境界 | 金額の合計と表示を分ける | 入出力と業務ロジックをどう分離するか |
| QuickCheck | reverseや検索の性質を検査する | 具体例から普遍的な仕様へどう進むか |

## まず失敗するテストを書く

最初に、実装のない関数を呼ぶテストを書きます。たとえば、次の仕様です。

```haskell
it "15の倍数をFizzBuzzと表現する" $
  fizzBuzz 15 `shouldBe` "FizzBuzz"
```

`fizzBuzz` の定義が存在しなければ、テストは実行以前にコンパイルエラーになります。ここで重要なのは、失敗を隠さないことです。GHCが示すexpected typeとactual type、未定義の名前、該当式を読み、仕様と型のどちらが不足しているかを確認します。GHC User’s GuideにはGHCiで型や式を調べる方法も整理されています。[1]

## 最小実装

最初のGreenでは、必要な具体例だけを通します。その後、15を3より先に判定する必要が分かります。

```haskell
fizzBuzz :: Int -> String
fizzBuzz n
  | n `mod` 15 == 0 = "FizzBuzz"
  | n `mod` 3 == 0  = "Fizz"
  | n `mod` 5 == 0  = "Buzz"
  | otherwise       = show n
```

この関数は入力を変更せず、同じ入力に対して同じ文字列を返します。したがって、標準入出力なしでテストできます。

## Maybeで「ない」を表す

ユーザー検索の型は次のようにしました。

```haskell
findUser :: UserId -> [User] -> Maybe User
```

存在する場合は `Just user`、存在しない場合は `Nothing` です。戻り値に特別なユーザーや `null` を使わないため、呼び出し側は「結果がない可能性」を型から読み取れます。

```haskell
findUser wanted = go
  where
    go [] = Nothing
    go (user : rest)
      | userId user == wanted = Just user
      | otherwise             = go rest
```

テストでは、存在するユーザー、存在しないユーザー、空リストを別々に確認しました。境界ケースを先に具体化すると、パターンマッチの基底ケースが自然に決まります。

## Eitherで検証エラーをデータにする

登録検証では、正常値と複数のエラーを分けます。

```haskell
validateRegistration :: Registration -> Either [ValidationError] Registration
```

名前が空、年齢が0未満または120超過という条件をそれぞれ検査し、エラーをリストへ蓄積します。例外を一つずつ投げる設計と異なり、入力者へ複数の修正点を一度に返せます。

```haskell
data ValidationError = EmptyName | InvalidAge
  deriving (Eq, Show)
```

ここではエラーを文字列ではなく独自型にしました。テストは `Left [EmptyName, InvalidAge]` のように、結果の構造そのものを仕様として固定します。

## 純粋関数とIOを分ける

`app/Main.hs` の `main :: IO ()` は、表示に限定します。合計計算は次の純粋関数です。

```haskell
calculateTotal :: [Integer] -> Integer
calculateTotal = sum
```

この分離により、テストはファイルや端末を準備せずに計算だけを検証できます。実務では、入力の取得、文字列の解析、ドメイン計算、結果の表示を別の関数へ分けることで、失敗箇所を小さくできます。

## QuickCheckで性質を書く

QuickCheckは、プログラムが満たすべき性質を仕様として与え、ランダム生成した多くのケースで検査するライブラリです。[3] 具体例だけでなく、次の性質をテストしました。

```haskell
property $ \xs -> myReverse (myReverse (xs :: [Int])) == xs
```

今回の実行では、この性質を100ケース確認し、成功しました。HspecはQuickCheckのpropertyをテストの中へ組み込めるため、例示ベースのテストと性質ベースのテストを同じ実行結果で追跡できます。[2]

QuickCheckが反例を出したときは、その入力を小さなHspecの具体例へ固定し、原因を観測します。一般化できる修正ができたら、性質テストを回帰テストとして残します。

## リファクタリング

Greenの後は、短くすることではなく、設計の意図が読みやすくなることを確認します。`myReverse` はリストの先頭と残りを直接操作する実装から、`foldl` と関数を使う形へ整理できます。一方、`findUser` は空リストと先頭要素の分解が教材上重要なので、再帰とパターンマッチを残しています。

`UserId` は `newtype` で包みました。裸の `Int` を受け渡すよりも、IDを表す値であることがシグネチャに表れます。年齢の範囲まで型で保証するスマートコンストラクタは、次の章の課題として残しています。

## 実行結果

```text
17 examples, 0 failures
+++ OK, passed 100 tests.
```

実行コマンドは次の二つです。

```bash
cabal test --offline --test-show-details=direct
cabal run
```

## まとめ

今回の流れで、仕様を具体例として書き、失敗を観測し、最小実装で通し、型と高階関数で設計を見直しました。Haskellらしさは、単にコードが短いことではありません。`Maybe` や `Either` で失敗をデータにし、純粋関数へロジックを寄せ、型と関数の組み合わせで不正な状態や責務の混在を減らすことです。

次の発展課題は、年齢のスマートコンストラクタ、ファイルIOの境界テスト、ソートの性質、エンコードとデコードの往復性です。どの課題でも、最初に仕様テストを書き、失敗を確認してから実装を始めます。

## References

[1]: https://downloads.haskell.org/ghc/latest/docs/users_guide/ "GHC User's Guide"
[2]: https://hspec.github.io/ "Hspec: A Testing Framework for Haskell"
[3]: https://hackage.haskell.org/package/QuickCheck "QuickCheck: Automatic testing of Haskell programs"
