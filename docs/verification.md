# 検証記録

## 実行環境

| 項目 | 実測値 |
|---|---|
| GHC | 9.4.7 |
| Cabal | 3.8.1.0 |
| Hspec | Cabalのテスト依存として解決 |
| QuickCheck | Cabalのテスト依存として解決 |

## 実行コマンドと結果

| 確認対象 | コマンド | 結果 |
|---|---|---|
| 全テスト・コンパイル警告 | `cabal test --offline --test-show-details=direct` | 成功。29 examples、0 failures、QuickCheck 2性質が各100ケース成功。警告なし。 |
| サンプル実行 | `cabal run` | 成功。FizzBuzz列と `total=250` を出力。 |
| Markdownのローカルリンク | `scripts/verify-doc-links.sh` | 成功。`Markdown local links: ok`。 |

## 検証した追加範囲

第7章は空名、範囲外年齢、年齢の上下限、複数エラー、正常構築を検証する。第8章はTSVの往復、空一覧、不正ID、不正列数、空タイトル、一時ファイルの保存・読込を検証する。第9章は、出力関数を`IORef`の手書きスパイへ差し替え、呼出結果を検証する。

QuickCheckは、`myReverse`の二重適用による往復性と、`findFirst`の返却値が必ず述語を満たすことを検証する。すべてのテストは `test/Spec.hs` から一回のコマンドで実行できる。
