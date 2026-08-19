# Haskell TDD Learning Lab

Haskellの構文を暗記するのではなく、**テスト → 実装 → リファクタリング → 型を使った設計**の順番で、関数型プログラミングの考え方を学ぶための小さな教材です。各章は完成コードと実行可能なテストを持ち、学習者は章ガイドにある最初のテストからRed → Green → Refactorを再現できます。

## 学習範囲

| 章 | 主題 | 完成コード | テスト |
|---|---|---|---|
| 1 | FizzBuzz、ガード、基本型 | `src/HaskellTdd/Fundamentals.hs` | `test/Spec.hs` |
| 2 | パターンマッチ、再帰、fold | 同上 | 同上 |
| 3 | `Maybe` とユーザー検索 | `src/HaskellTdd/MaybeUser.hs` | 同上 |
| 4 | `Either` と複数エラーの検証 | `src/HaskellTdd/Validation.hs` | 同上 |
| 5 | 型と純粋関数、IO境界 | `src/HaskellTdd/PureIO.hs`、`app/Main.hs` | 同上 |
| 6 | QuickCheckによる性質 | `test/Spec.hs` | 同上 |

この版では、添付指示書の中心概念を一つのCabalプロジェクトへまとめています。各章の未実装範囲や次の練習問題は `coverage-matrix.md` に明示しています。

## 必要環境

GHC 9.4以降とCabal 3.8以降を想定します。依存関係はCabalが解決します。

## セットアップと実行

```bash
cabal update
cabal build
cabal test
cabal run
```

テストを先に読み、章ガイドにある最小の失敗例を追加してから、完成コードと比較してください。警告も学習材料にするため、ビルドでは `-Wall` などの警告を有効にしています。

## ディレクトリ構成

```text
app/Main.hs                         # IOと純粋ロジックの境界を示す実行例
src/HaskellTdd/                     # 完成した純粋関数と型
  Fundamentals.hs
  MaybeUser.hs
  Validation.hs
  PureIO.hs
test/Spec.hs                        # HspecとQuickCheck
chapters/                            # 章別ガイド
SUMMARY.md                          # 学習順序
coverage-matrix.md                  # 指示書との対応
DESIGN.md                           # Haskell固有の設計判断
article/haskell-tdd-learning.md    # 技術記事初稿
```

## TDDの進め方

各章では、まず仕様を一つ選び、振る舞いテストを書きます。テストが失敗することを確認し、最小の実装で通し、その後にパターンマッチ、再帰、高階関数、`Maybe`、`Either`、独自型などを使って設計を改善します。完成版だけを読むのではなく、コミット履歴の `red/`、`green/`、`refactor/` を参照すると学習しやすくなります。

## ライセンスと帰属

この教材は添付された学習方針を基に新規に構成したものです。特定の既存教材の文章やコードは大量に複製していません。HspecとQuickCheckは、それぞれの公式ドキュメントを参照してください。
