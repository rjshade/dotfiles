import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.Hooks.DynamicLog
import XMonad.Layout.Grid
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Config.Gnome

myWorkSpaces = ["terminal","chrome"]
myNormalBorderColor  = "#073642"
myFocusedBorderColor = "#586e75"
myBorderWidth = 1

myTerminal = "urxvt"

myBar = "xmobar"

myPP = xmobarPP { 
                    ppCurrent = xmobarColor "#93a1a1" "",
                    ppTitle = xmobarColor "#586e65" "",
                    ppHiddenNoWindows = xmobarColor "#073642" "",
                    ppHidden = xmobarColor "#586e75" "",
                    ppLayout = xmobarColor "#586e75" ""
                }

-- keybinding to toggle gap for xmobar
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

myConfig = gnomeConfig
        {
          workspaces = myWorkSpaces
        , terminal              = myTerminal
        , borderWidth           = myBorderWidth
        , normalBorderColor     = myNormalBorderColor
        , focusedBorderColor    = myFocusedBorderColor
        }

main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig
