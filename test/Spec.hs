module Main where

import Test.Hspec
import Test.QuickCheck
import HaskellTdd.Fundamentals
import HaskellTdd.MaybeUser
import HaskellTdd.PureIO
import HaskellTdd.Validation

main :: IO ()
main = hspec $ do
  describe "基礎: fizzBuzz" $ do
    it "3の倍数をFizzと表現する" $
      fizzBuzz 3 `shouldBe` "Fizz"
    it "5の倍数をBuzzと表現する" $
      fizzBuzz 5 `shouldBe` "Buzz"
    it "15の倍数をFizzBuzzと表現する" $
      fizzBuzz 15 `shouldBe` "FizzBuzz"
    it "それ以外は数値を文字列化する" $
      fizzBuzz 7 `shouldBe` "7"

  describe "再帰とリスト" $ do
    it "階乗を計算する" $
      factorial 5 `shouldBe` 120
    it "Fibonacciの先頭を計算する" $
      map fibonacci [0 .. 5] `shouldBe` [0, 1, 1, 2, 3, 5]
    it "独自reverseは順序を反転する" $
      myReverse [1, 2, 3] `shouldBe` [3, 2, 1]
    it "条件に合う最初の要素をMaybeで返す" $
      findFirst (> (3 :: Int)) [1, 2, 4, 5] `shouldBe` Just 4
    it "見つからない場合はNothingを返す" $
      findFirst (> (9 :: Int)) [1, 2, 4, 5] `shouldBe` Nothing

  describe "Maybe: user search" $ do
    let users = [User (UserId 1) "Ada" 36, User (UserId 2) "Grace" 28]
    it "存在するユーザーをJustで返す" $
      findUser (UserId 2) users `shouldBe` Just (User (UserId 2) "Grace" 28)
    it "空リストではNothingを返す" $
      findUser (UserId 1) [] `shouldBe` Nothing

  describe "Either: registration validation" $ do
    it "正常な入力をRightで返す" $
      validateRegistration (Registration "Ada" 36) `shouldBe` Right (Registration "Ada" 36)
    it "名前と年齢の複数エラーをLeftで返す" $
      validateRegistration (Registration "" 121) `shouldBe` Left [EmptyName, InvalidAge]

  describe "IOと純粋関数の分離" $ do
    it "合計計算は純粋関数として検証できる" $
      calculateTotal [10, 20, 5] `shouldBe` 35
    it "表示形式を純粋関数として検証できる" $
      renderTotal [10, 20, 5] `shouldBe` "total=35"

  describe "QuickCheck properties" $ do
    it "reverseを2回適用すると元に戻る" $
      property $ \xs -> myReverse (myReverse (xs :: [Int])) == xs
    it "findFirstは見つかった値を必ず条件を満たすものとして返す" $
      property $ \xs n -> case findFirst (> n) (xs :: [Int]) of
        Nothing -> all (<= n) xs
        Just found -> found > n
