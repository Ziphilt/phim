module Main (main) where

import qualified Graphics.X11 as X
import qualified Graphics.X11.Xlib.Extras as XExtras
-- import qualified System.Posix as P
-- import qualified Control.Monad as M
-- import qualified Data.Bits as B
import Data.Bits ((.|.))

main :: IO ()
main = do
    d <- X.openDisplay ""
    let blackColor = X.blackPixel d (X.defaultScreen d)
    let whiteColor = X.whitePixel d (X.defaultScreen d)
    w <- X.createSimpleWindow
        d (X.defaultRootWindow d) 0 0 200 100 0 blackColor whiteColor
    gc <- X.createGC d w

    X.selectInput d w (X.exposureMask .|. X.keyPressMask)
    X.storeName d w "phim"
    X.mapWindow d w
    X.setForeground d gc blackColor

    loop d w gc
    -- X.drawLine d w gc 10 60 180 20
    -- X.flush d
    -- M.forever $ P.sleep 10

    X.freeGC d gc
    X.closeDisplay d

    return ()

loop :: X.Display -> X.Window -> X.GC -> IO ()
loop d w gc = do
    exit <- X.allocaXEvent (\xev -> do
        X.nextEvent d xev
        event <- XExtras.getEvent xev
        print event
        X.clearWindow d w
        case event of
            XExtras.ExposeEvent{} -> do
                X.fillRectangle d w gc 20 20 10 10
                return False
            XExtras.KeyEvent{XExtras.ev_keycode = keycode} -> do
                X.drawString d w gc 50 50 (show keycode)
                return (keycode == 66)
            _ -> return False
        )
    case exit of
        True -> return ()
        False -> loop d w gc
