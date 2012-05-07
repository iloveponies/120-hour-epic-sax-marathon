import Text.Pandoc
import System.Environment (getArgs)

handleExercises format (Para (title@(Emph [Str "Exercise", Str ":"]):rest))
    = case format of
        "html" -> Para $ [ RawInline "html" $ "<section class=\"alert alert-success\">"
                         , title
                         ] ++ rest ++ [ RawInline "html" $ "</section>" ]
handleExercises _ x = x

main :: IO ()
main = do
    args <- getArgs
    toJsonFilter . handleExercises $ case args of
        [f] -> f
        []  -> "html"
