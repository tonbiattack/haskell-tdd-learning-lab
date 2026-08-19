# 4. Eitherで検証エラーを表現する

`validateRegistration` は `Either [ValidationError] Registration` を返します。正常入力は `Right`、名前が空または年齢が範囲外なら `Left` です。複数エラーを蓄積するため、例外を投げる設計とは異なり、呼び出し側がエラーをデータとして扱えます。

`ValidationError` と `Registration` は独自型です。`src/HaskellTdd/Validation.hs` を読み、文字列や整数だけを直接やり取りする設計との差を確認してください。
