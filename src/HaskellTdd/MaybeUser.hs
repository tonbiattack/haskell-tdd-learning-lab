module HaskellTdd.MaybeUser
  ( UserId(..)
  , User(..)
  , findUser
  ) where

newtype UserId = UserId Int
  deriving (Eq, Show)

data User = User
  { userId   :: UserId
  , userName :: String
  , userAge  :: Int
  } deriving (Eq, Show)

findUser :: UserId -> [User] -> Maybe User
findUser wanted = go
  where
    go [] = Nothing
    go (user : rest)
      | userId user == wanted = Just user
      | otherwise             = go rest
