# 3. Maybeで失敗を表現する

`findUser :: UserId -> [User] -> Maybe User` をTDDします。存在する場合は `Just user`、存在しない場合と空リストは `Nothing` です。`null` を先に呼び出して分岐するのではなく、パターンマッチでデータの形を直接扱います。

完成実装は `src/HaskellTdd/MaybeUser.hs`、テストは `test/Spec.hs` にあります。次の課題は、`Maybe` の結果を表示用メッセージへ変換する純粋関数です。
