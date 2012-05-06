import Text.Pandoc
import System.Environment (getArgs)

handleAsides format (Para (title@(Emph [Str "Aside", Str ":"]):rest))
    = case format of
        "html" -> Para $ [ RawInline "html" $ "<aside class=\"alert alert-info\">" ] ++ rest ++ [ RawInline "html" $ "</aside>" ]
handleAsides _ x = x

main :: IO ()
main = do
    args <- getArgs
    toJsonFilter . handleAsides $ case args of
        [f] -> f
        []  -> "html"
