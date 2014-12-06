import qualified Graphics.UI.Gtk as G
import Graphics.UI.Gtk (AttrOp((:=)))

main :: IO ()
main = do
        G.initGUI
        window <- G.windowNew
        button <- G.buttonNew
        G.set window [G.containerBorderWidth := 10, G.containerChild := button]
        G.set button [G.buttonLabel := "Hello World"]
        G.onClicked button (putStrLn "Hello World")
        G.onDestroy window G.mainQuit
        G.widgetShowAll window
        G.mainGUI
