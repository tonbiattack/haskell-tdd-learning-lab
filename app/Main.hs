module Main where

import HaskellTdd.Fundamentals (fizzBuzz)
import HaskellTdd.PureIO (renderTotal)

main :: IO ()
main = do
  putStrLn "Haskell TDD Learning Lab"
  putStrLn (unwords (map fizzBuzz [1 .. 15]))
  putStrLn (renderTotal [120, 80, 50])
