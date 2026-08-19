# Haskell TDD Learning Lab

**Haskellを、テストから実装へ進む形で学ぶ実行可能な教材**です。小さな振る舞いテストを一つ書き、最小実装で通し、型・命名・責務を整える **Red → Green → Refactor** を繰り返します。[Learn Go with Tests][1] の「テストで言語と設計を学ぶ」という方針から着想を得ていますが、文章・コードを複製せず、Haskellの型、純粋関数、代数的データ型、IO境界へ置き換えて新規に構成しています。

> **進め方:** 最初のテストだけを読み、完成実装を隠すか削除してRedを観察してください。そのテストを通す最小のコードを書き、Greenになってからリファクタリングします。完成実装を先に読み切らず、テスト名、期待値、GHCの型エラーを次の小さな変更の手掛かりにします。

## ねらい

| 項目 | この教材で行うこと |
|---|---|
| 言語・実行環境 | Haskell 2010、GHC 9.4以降、Cabal 3.8以降 |
| テスト | Hspecによる具体例とQuickCheckによる性質テスト |
| 基礎 | ガード、パターンマッチ、再帰、`map`、`fold`、純粋関数 |
| 型と失敗 | `Maybe`、`Either`、`newtype`、スマートコンストラクタ |
| アプリケーション境界 | 関数引数による依存の差し替え、TSVファイルI/O、IO分離 |
| 発展 | タイトルの文字制約、JSON、IO例外、QuickCheck生成器、型クラス |

Hspecはテスト記述用DSLとQuickCheck連携を提供します。[2] QuickCheckは、関数が満たすべき性質を多数の生成入力で検査します。[3]

## 必要環境と開始方法

GHCとCabalを準備してから、次のコマンドを実行します。最初の依存取得にはネットワーク接続が必要です。

```bash
git clone https://github.com/tonbiattack/haskell-tdd-learning-lab.git
cd haskell-tdd-learning-lab
cabal update
cabal test --test-show-details=direct
cabal run
```

キャッシュ済みの依存関係だけで検証する環境では、`cabal test --offline --test-show-details=direct` を使えます。テストは全Hspec例とQuickCheckの性質を実行し、`cabal run` はFizzBuzzと合計レポートの実行例を出力します。

## 学習順序

### 基礎：値・関数・型を小さく固める

| # | 章 | 主題 | 完成実装 |
|---:|---|---|---|
| 1 | [FizzBuzzとガード](haskell-fundamentals/01-fizzbuzz-and-guards.md) | 型シグネチャ、ガード、具体例 | `Fundamentals.fizzBuzz` |
| 2 | [再帰・パターンマッチ・fold](haskell-fundamentals/02-recursion-patterns-and-fold.md) | 基底ケース、再帰、高階関数 | `factorial`、`fibonacci`、`myReverse` |
| 3 | [Maybeでユーザーを検索する](haskell-fundamentals/03-maybe-user-search.md) | 不在を値として表す | `MaybeUser.findUser` |
| 4 | [Eitherで入力を検証する](haskell-fundamentals/04-either-validation.md) | 検証エラーの蓄積 | `Validation.validateRegistration` |
| 5 | [純粋関数とIOを分離する](haskell-fundamentals/05-pure-functions-and-io.md) | 計算・表示・`main` の責務 | `PureIO`、`Main` |
| 6 | [QuickCheckで性質を書く](haskell-fundamentals/06-quickcheck-properties.md) | 具体例から普遍的仕様へ | `myReverse`、`findFirst` |

### アプリケーション：不変条件と外部境界を扱う

| # | 章 | 主題 | 完成実装 |
|---:|---|---|---|
| 7 | [スマートコンストラクタ](build-an-application/07-smart-constructors.md) | 不正状態を構築時に減らす | `SafeRegistration` |
| 8 | [ファイルI/O](build-an-application/08-file-io.md) | 純粋なTSV変換と一時ファイル統合テスト | `TodoStore` |
| 9 | [関数による依存性注入](build-an-application/09-function-dependency-injection.md) | 出力依存の差し替えと手書きスパイ | `Report` |

### 補足：テストを役割ごとに選ぶ

| # | 章 | 主題 |
|---:|---|---|
| 10 | [テスト戦略](questions-and-answers/10-test-strategy.md) | Hspec、QuickCheck、統合テスト、型エラーの観測 |

`SUMMARY.md` は章を順に読むための索引です。設計判断は `DESIGN.md`、採用範囲と未実装項目は `coverage-matrix.md`、既存教材をどう参照して構成したかは `docs/research-notes.md` で確認できます。

## TDDの最小サイクル

| 段階 | 行うこと | 確認すること |
|---|---|---|
| Red | 一つの振る舞いを表すHspecテストを書く | 未定義の名前、型エラー、または期待どおりの失敗を観察する |
| Green | テストを通す最小限の実装を加える | 全テストが成功する |
| Refactor | 重複、命名、責務、型を改善する | テストが安全網として成功し続ける |

一度に複数の振る舞いを加えません。失敗時は、テスト名、期待値、実際値、入力・出力の型を確認し、次の最小実験を決めます。

## リポジトリ構成

```text
app/Main.hs                        実行用のIO境界
src/HaskellTdd/                    完成実装
  Fundamentals.hs                  基礎の純粋関数
  MaybeUser.hs                     Maybeによる検索
  Validation.hs                    Eitherによる検証
  SafeRegistration.hs              スマートコンストラクタ
  TodoStore.hs                     TSV変換とファイルI/O
  Report.hs                        関数による依存性注入
test/Spec.hs                       Hspec、QuickCheck、I/O統合テスト
haskell-fundamentals/              基礎章ガイド
build-an-application/              アプリケーション章ガイド
questions-and-answers/             補足章ガイド
scripts/verify-doc-links.sh        Markdownのローカルリンク検証
docs/research-notes.md             参照教材と設計判断
docs/tdd-log.md                   TDDと実測の記録
```

## 検証済みの範囲

GHC 9.4.7とCabal 3.8.1.0で、全Hspec例、QuickCheckの性質、一時ファイルを用いるTSVの保存・読込テストを実行します。続けて `scripts/verify-doc-links.sh` でMarkdownのローカルリンクを確認します。詳細な実測は `docs/verification.md` に記録します。

## 参考資料

[1]: https://quii.gitbook.io/learn-go-with-tests "Learn Go with Tests"
[2]: https://hspec.github.io/ "Hspec: A Testing Framework for Haskell"
[3]: https://hackage.haskell.org/package/QuickCheck "QuickCheck: Automatic testing of Haskell programs"
