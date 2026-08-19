# 3. Maybeでユーザーを検索する

## 目的

`findUser :: UserId -> [User] -> Maybe User` をTDDし、見つからない状態を例外や特別なダミー値ではなく型で表します。`null` を先に呼び出して分岐するのではなく、空リストと先頭要素・残りをパターンマッチします。

## 最初のテスト

まず、存在するユーザーを返す一例を追加します。

```haskell
findUser (UserId 2) users `shouldBe` Just (User (UserId 2) "Grace" 28)
```

`findUser` が未定義の状態ではコンパイルエラーがRedです。最小実装でこの例を通した後、存在しないIDと空リストを順に追加します。

## 完成実装

完成コードは `src/HaskellTdd/MaybeUser.hs`、振る舞いテストは `test/Spec.hs` の「Maybe: user search」です。`UserId` は `newtype` で包み、IDと裸の`Int`を区別します。

## リファクタリングの問い

結果がないときに、空の`User`や例外を使うと、呼び出し側は失敗を見落とせます。`Maybe User` を返すと、呼び出し側は `Just` と `Nothing` の両方を処理する必要があります。

## 次に増やす振る舞い

検索結果を表示用の文字列へ変換する純粋関数を追加してください。見つかった場合と見つからない場合を別のHspec例で仕様化します。

## 実行

```bash
cabal test --offline
```
