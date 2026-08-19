module HaskellTdd.SafeRegistration
  ( UserName
  , Age
  , ValidRegistration(..)
  , RegistrationError(..)
  , mkUserName
  , mkAge
  , mkValidRegistration
  ) where

newtype UserName = UserName String
  deriving (Eq, Show)

newtype Age = Age Int
  deriving (Eq, Show)

data ValidRegistration = ValidRegistration
  { validRegistrationName :: UserName
  , validRegistrationAge  :: Age
  } deriving (Eq, Show)

data RegistrationError
  = NameIsEmpty
  | AgeOutOfRange
  deriving (Eq, Show)

mkUserName :: String -> Either RegistrationError UserName
mkUserName ""   = Left NameIsEmpty
mkUserName name = Right (UserName name)

mkAge :: Int -> Either RegistrationError Age
mkAge age
  | age < 0 || age > 120 = Left AgeOutOfRange
  | otherwise            = Right (Age age)

mkValidRegistration :: String -> Int -> Either [RegistrationError] ValidRegistration
mkValidRegistration name age =
  case (mkUserName name, mkAge age) of
    (Right validName, Right validAge) -> Right (ValidRegistration validName validAge)
    _                                  -> Left errors
  where
    errors = concat
      [ [NameIsEmpty | name == ""]
      , [AgeOutOfRange | age < 0 || age > 120]
      ]
