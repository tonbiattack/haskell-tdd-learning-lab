module Main where

import Control.Exception (bracket)
import Data.Either (isRight)
import Data.IORef (modifyIORef', newIORef, readIORef)
import System.Directory (removeFile)
import System.IO (hClose, openTempFile)
import Test.Hspec
import Test.QuickCheck
import HaskellTdd.Fundamentals
import HaskellTdd.MaybeUser
import HaskellTdd.PureIO
import HaskellTdd.Report
import HaskellTdd.SafeRegistration
import HaskellTdd.TodoStore
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
      myReverse ([1, 2, 3] :: [Int]) `shouldBe` [3, 2, 1]
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

  describe "型による不変条件" $ do
    it "空文字列からUserNameを構築しない" $
      mkUserName "" `shouldBe` Left NameIsEmpty
    it "年齢の範囲外をAgeとして構築しない" $
      mkAge 121 `shouldBe` Left AgeOutOfRange
    it "年齢の下限と上限をAgeとして構築できる" $ do
      mkAge 0 `shouldSatisfy` isRight
      mkAge 120 `shouldSatisfy` isRight
    it "複数の不正条件を同時に返す" $
      mkValidRegistration "" (-1) `shouldBe` Left [NameIsEmpty, AgeOutOfRange]
    it "検証済みの名前と年齢だけで登録情報を構築する" $
      mkValidRegistration "Ada" 36 `shouldSatisfy` isRight

  describe "IOと純粋関数の分離" $ do
    it "合計計算は純粋関数として検証できる" $
      calculateTotal [10, 20, 5] `shouldBe` 35
    it "表示形式を純粋関数として検証できる" $
      renderTotal [10, 20, 5] `shouldBe` "total=35"

  describe "ファイルI/O境界" $ do
    it "TSVのエンコードとデコードを純粋関数として往復できる" $
      parseTodos (renderTodos sampleTodos) `shouldBe` Right sampleTodos
    it "空のTODO一覧を受け付ける" $
      parseTodos "" `shouldBe` Right []
    it "不正なIDを構造化エラーとして返す" $
      parseTodos "zero\t学習する\n" `shouldBe` Left (InvalidTodoId "zero")
    it "列が多い行を構造化エラーとして返す" $
      parseTodos "1\t学習する\t余分\n" `shouldBe` Left (InvalidTodoRow "1\t学習する\t余分")
    it "空のタイトルを構造化エラーとして返す" $
      parseTodos "1\t\n" `shouldBe` Left (InvalidTodoTitle "")
    it "一時ファイルへ保存したTODOを読み戻せる" $
      withTemporaryTodoFile $ \path -> do
        saveTodos path sampleTodos
        loaded <- loadTodos path
        loaded `shouldBe` Right sampleTodos

  describe "依存性注入" $ do
    it "出力関数を手書きスパイへ差し替えてレポートを確認できる" $ do
      messages <- newIORef []
      let spy message = modifyIORef' messages (++ [message])
      runReport spy [120, 80, 50]
      captured <- readIORef messages
      captured `shouldBe` ["total=250"]

  describe "QuickCheck properties" $ do
    it "reverseを2回適用すると元に戻る" $
      property $ \xs -> myReverse (myReverse (xs :: [Int])) == xs
    it "findFirstは見つかった値を必ず条件を満たすものとして返す" $
      property $ \xs n -> case findFirst (> n) (xs :: [Int]) of
        Nothing -> all (<= n) xs
        Just found -> found > n

sampleTodos :: [Todo]
sampleTodos = [Todo 1 "Haskellを学ぶ", Todo 2 "テストを書く"]

withTemporaryTodoFile :: (FilePath -> IO a) -> IO a
withTemporaryTodoFile = bracket acquire removeFile
  where
    acquire = do
      (path, handle) <- openTempFile "/tmp" "haskell-tdd-todos.tsv"
      hClose handle
      pure path
