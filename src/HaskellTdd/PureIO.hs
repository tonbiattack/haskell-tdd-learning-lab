module HaskellTdd.PureIO
  ( calculateTotal
  , renderTotal
  ) where

calculateTotal :: [Integer] -> Integer
calculateTotal = sum

renderTotal :: [Integer] -> String
renderTotal amounts = "total=" ++ show (calculateTotal amounts)
