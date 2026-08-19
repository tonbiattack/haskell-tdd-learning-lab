# 4. Eitherで入力を検証する

## 目的

`validateRegistration :: Registration -> Either [ValidationError] Registration` をTDDし、入力エラーを例外ではなくデータとして返します。正常入力は `Right`、名前が空または年齢が範囲外なら `Left` です。この章では、フォーム入力を題材に複数エラーを蓄積します。

## 最初のテスト

最初に正常入力を通すテストを追加します。

```haskell
validateRegistration (Registration "Ada" 36)
  `shouldBe` Right (Registration "Ada" 36)
```

最小実装でGreenにした後、空の名前、範囲外の年齢、両方が不正な入力を一つずつ追加します。複数エラーのテストを先に書くことで、最初に見つけたエラーだけを返す実装との違いを明確にします。

## 完成実装

完成コードは `src/HaskellTdd/Validation.hs`、振る舞いテストは `test/Spec.hs` の「Either: registration validation」です。`ValidationError` と `Registration` は独自型であり、文字列だけのエラー通知よりテスト対象の構造が明確です。

## リファクタリングの問い

単一のエラーで処理を止めるべきか、入力者へ複数の修正点をまとめて返すべきかを仕様から決めます。後者を採用したため、戻り値は `Either [ValidationError] Registration` です。

## 次に増やす振る舞い

入力を受け取る時点で不正な名前・年齢を構築しないようにしたい場合は、第7章のスマートコンストラクタへ進みます。

## 実行

```bash
cabal test --offline
```
