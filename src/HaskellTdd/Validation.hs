module HaskellTdd.Validation
  ( ValidationError(..)
  , Registration(..)
  , validateRegistration
  ) where

data ValidationError
  = EmptyName
  | InvalidAge
  deriving (Eq, Show)

data Registration = Registration
  { registrationName :: String
  , registrationAge  :: Int
  } deriving (Eq, Show)

validateRegistration :: Registration -> Either [ValidationError] Registration
validateRegistration registration =
  case errors of
    [] -> Right registration
    _  -> Left errors
  where
    errors = concat
      [ [EmptyName | null (registrationName registration)]
      , [InvalidAge | registrationAge registration < 0 || registrationAge registration > 120]
      ]
