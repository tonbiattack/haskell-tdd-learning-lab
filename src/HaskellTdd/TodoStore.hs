module HaskellTdd.TodoStore
  ( Todo(..)
  , TodoStoreError(..)
  , renderTodos
  , parseTodos
  , saveTodos
  , loadTodos
  ) where

data Todo = Todo
  { todoId    :: Int
  , todoTitle :: String
  } deriving (Eq, Show)

data TodoStoreError
  = InvalidTodoRow String
  | InvalidTodoId String
  | InvalidTodoTitle String
  deriving (Eq, Show)

renderTodos :: [Todo] -> String
renderTodos = unlines . map renderTodo
  where
    renderTodo todo = show (todoId todo) ++ "\t" ++ todoTitle todo

parseTodos :: String -> Either TodoStoreError [Todo]
parseTodos = traverse parseTodo . filter (not . null) . lines

parseTodo :: String -> Either TodoStoreError Todo
parseTodo row =
  case splitTab row of
    [identifier, title] -> Todo <$> parseIdentifier identifier <*> parseTitle title
    _                   -> Left (InvalidTodoRow row)

splitTab :: String -> [String]
splitTab = splitOn '\t'

splitOn :: Char -> String -> [String]
splitOn separator = foldr step [""]
  where
    step character parts@(current : rest)
      | character == separator = "" : parts
      | otherwise              = (character : current) : rest
    step _ [] = []

parseIdentifier :: String -> Either TodoStoreError Int
parseIdentifier value =
  case reads value of
    [(identifier, "")] | identifier > 0 -> Right identifier
    _                                     -> Left (InvalidTodoId value)

parseTitle :: String -> Either TodoStoreError String
parseTitle ""    = Left (InvalidTodoTitle "")
parseTitle title = Right title

saveTodos :: FilePath -> [Todo] -> IO ()
saveTodos path = writeFile path . renderTodos

loadTodos :: FilePath -> IO (Either TodoStoreError [Todo])
loadTodos path = parseTodos <$> readFile path
