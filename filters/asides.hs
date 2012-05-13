import Text.Pandoc
import System.Environment (getArgs)

htmlAside r c = Para $ [ RawInline "html" $ "<aside class=\"alert alert-" ++ c ++ "\">" ] ++
                       r ++
                       [ RawInline "html" $ "</aside>" ]


handleAsides format (Para ((Emph [Str "Aside", Str ":"]):rest))
        = case format of
            "html" -> htmlAside rest "info"
handleAsides format (Para ((Emph [Str "Note", Str ":"]):rest))
        = case format of
            "html" -> htmlAside rest "error"
handleAsides _ x = x

main :: IO ()
main = do
    args <- getArgs
    toJsonFilter . handleAsides $ case args of
        [f] -> f
        []  -> "html"
