import Text.Pandoc
import System.Environment (getArgs)

handleExercises format (Para ((Emph [Str "Exercise"]):rest))
    = case format of
        "html" -> Para $ [ RawInline "html" $ "<section class=\"alert alert-success\">"
                         , Emph [Str "Exercise"]
                         ] ++ rest ++ [ RawInline "html" $ "</section>" ]
handleExercises _ x = x

main :: IO ()
main = do
    args <- getArgs
    toJsonFilter . handleExercises $ case args of
        [f] -> f
        []  -> "html"
