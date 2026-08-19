# 対応表と実装範囲

この教材は、テストで言語と設計を学ぶ方針をHaskellへ再構成したものです。参照教材の文章やコードは複製せず、概念をHaskellの型、関数、IO境界へ置き換えています。構成上の調査と置換理由は `docs/research-notes.md` と `DESIGN.md` に記録しています。

| 学習テーマ | 状態 | 章・実装・証拠 |
|---|---|---|
| 基本文法・純粋関数 | 実装済み | 第1章、`Fundamentals.hs`、`PureIO.hs`、Hspec例 |
| パターンマッチ・再帰 | 実装済み | 第2章、`factorial`、`fibonacci`、`findFirst` |
| `map`・`filter`・`fold` | 実装済み | 第2章、`myReverse`、QuickCheckの往復性 |
| `Maybe` | 実装済み | 第3章、`findUser` の存在・不在・空リストのテスト |
| `Either` | 実装済み | 第4章、`validateRegistration` と複数エラーのテスト |
| 独自型・`newtype` | 実装済み | 第3・4・7章、`UserId`、`UserName`、`Age`、エラー型 |
| 型で不正状態を減らす | 実装済み | 第7章、`mkUserName`、`mkAge`、`mkValidRegistration` |
| IOと純粋関数の分離 | 実装済み | 第5章、`PureIO.hs` と `app/Main.hs` |
| Hspec | 実装済み | 全章、`test/Spec.hs` |
| QuickCheck | 実装済み | 第6章、reverse・検索結果の性質テスト |
| 関数による依存の差し替え | 実装済み | 第9章、`Report.runReport` と `IORef` の手書きスパイ |
| ファイルI/O | 実装済み | 第8章、`TodoStore.hs` と一時ファイルの保存・読込テスト |
| エンコード/デコード | 部分実装 | TSVの往復性は実装済み。タイトルのエスケープやJSON形式は発展課題 |
| HTTP境界 | 未着手 | HaskellのWebフレームワーク選定後の発展課題 |
| 非同期・並行性 | 未着手 | `async`、STM、キャンセルを扱う発展課題 |

「実装済み」は、章ガイド、完成実装、振る舞いテストがすべて揃っている項目です。「部分実装」と「未着手」は学習順序を誤解させないために残しています。
