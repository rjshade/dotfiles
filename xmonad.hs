import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import qualified XMonad.StackSet as W
import XMonad.Layout.NoBorders

import XMonad.Hooks.DynamicLog

import XMonad.Layout.Grid

{-import XMonad.Layout.ResizableTile-}
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
-- Data.List provides isPrefixOf isSuffixOf and isInfixOf
import Data.List

import XMonad.Config.Gnome

-- for viewShift
import Control.Monad (liftM2)
import qualified XMonad.StackSet as W

-- for fullscreen Chrome
import XMonad.Hooks.EwmhDesktops

-- this manage hook makes nameless windows float by default
-- OpenGL windows have name "" for some reason, so this makes
-- my apps float
myManageHook :: ManageHook
myManageHook = composeAll . concat $
    [ [ title =? t --> doFloat | t <- myTitleFloats]
    , [ className =? c --> doFloat | c <- myClassFloats ]
    , [ fmap ( c `isInfixOf`) className --> doFloat | c <- myMatchAnywhereFloatsC ]
    , [ fmap ( c `isInfixOf`) title     --> doFloat | c <- myMatchAnywhereFloatsT ]
    , [(className =? "Firefox" <&&> resource =? "Dialog") --> doFloat] 
    , [ isFullscreen --> (doF W.focusDown <+> doFullFloat) ]
    -- shifts keepassx to its own workspace, and moves view there as well
    , [ className =? "Keepassx" --> viewShift "keepassx" ]
    ]
    where
        myTitleFloats = ["Shiretoko - Choose User Profile"] 
        myClassFloats = [""]
        myMatchAnywhereFloatsC = ["Google","Pidgin","feh","Tilda"]
        myMatchAnywhereFloatsT = ["VLC","KGS"]
        viewShift = doF . liftM2 (.) W.greedyView W.shift

myWorkSpaces = ["dev:1","dev:2","corp","home","irc","float"]
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
        , handleEventHook       = fullscreenEventHook
        , manageHook = myManageHook <+> manageHook defaultConfig
        }

main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig
