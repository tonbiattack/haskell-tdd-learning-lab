module HaskellTdd.Fundamentals
  ( fizzBuzz
  , factorial
  , fibonacci
  , myReverse
  , findFirst
  ) where

fizzBuzz :: Int -> String
fizzBuzz n
  | n `mod` 15 == 0 = "FizzBuzz"
  | n `mod` 3 == 0  = "Fizz"
  | n `mod` 5 == 0  = "Buzz"
  | otherwise       = show n

factorial :: Integer -> Integer
factorial n
  | n < 0     = error "factorial is undefined for negative numbers"
  | otherwise = go n 1
  where
    go 0 acc = acc
    go k acc = go (k - 1) (acc * k)

fibonacci :: Int -> Integer
fibonacci n
  | n < 0     = error "fibonacci is undefined for negative indices"
  | otherwise = go n 0 1
  where
    go 0 a _ = a
    go k a b = go (k - 1) b (a + b)

myReverse :: [a] -> [a]
myReverse = foldl (flip (:)) []

findFirst :: (a -> Bool) -> [a] -> Maybe a
findFirst _ [] = Nothing
findFirst predicate (x : xs)
  | predicate x = Just x
  | otherwise   = findFirst predicate xs
