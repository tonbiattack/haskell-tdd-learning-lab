# 5. 純粋関数とIOを分離する

`app/Main.hs` は入力・計算・条件分岐・出力を一つへ混ぜず、表示の境界だけを担当します。`calculateTotal` と `renderTotal` は `src/HaskellTdd/PureIO.hs` の純粋関数です。

この構造では、テストがファイルや標準入出力に依存しません。次の課題として、`getLine` で得た文字列を純粋なパーサーへ渡し、`IO` は入出力だけに限定してください。

```bash
cabal run
cabal test
```
