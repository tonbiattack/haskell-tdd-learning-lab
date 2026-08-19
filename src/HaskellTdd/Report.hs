module HaskellTdd.Report
  ( Writer
  , runReport
  ) where

import HaskellTdd.PureIO (renderTotal)

type Writer = String -> IO ()

runReport :: Writer -> [Integer] -> IO ()
runReport writer amounts = writer (renderTotal amounts)
