# 7. スマートコンストラクタで不変条件を入口へ寄せる

## 目的

`String` と `Int` をそのまま登録データとして受け渡す代わりに、空でない名前と範囲内の年齢だけを構築できる型へ変換します。ここでの狙いは、検証済みであることを呼び出し規約ではなく型の組み合わせに残すことです。

## 最初のテスト

最初に、空文字列から名前を作れないことをテストします。

```haskell
mkUserName "" `shouldBe` Left NameIsEmpty
```

この時点で `mkUserName` がなければ、未定義の名前によるコンパイルエラーがRedです。次に、空文字列だけを拒否する最小実装でGreenにし、年齢の境界値、複数エラー、正常値を一つずつ増やします。

## 完成実装

完成コードは `src/HaskellTdd/SafeRegistration.hs`、振る舞いテストは `test/Spec.hs` の「型による不変条件」です。`UserName` と `Age` は外部からコンストラクタを使えない抽象型として公開し、`mkUserName` と `mkAge` が唯一の構築経路になります。`mkValidRegistration` は入力エラーを蓄積して `Either [RegistrationError] ValidRegistration` を返します。

## リファクタリングの問い

`Maybe` だけで不正理由を捨ててよいか、単一の `Either RegistrationError` で十分か、または複数エラーを返す必要があるかを仕様から決めます。この章ではフォーム入力を題材にするため、複数エラーを返します。

## 次に増やす振る舞い

名前の前後空白をどう扱うかを先に仕様化し、トリムするのか拒否するのかをテストで決めてください。

## 実行

```bash
cabal test --offline
```
