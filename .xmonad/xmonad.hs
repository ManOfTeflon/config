import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Actions.Navigation2D
import XMonad.Hooks.FadeInactive
import XMonad.Layout.Spacing
import System.IO

import qualified XMonad.StackSet as W

myLogHook :: X ()
myLogHook = fadeInactiveLogHook fadeAmount
    where fadeAmount = 0.85

main = do
  xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmobarrc"
  xmonad $ withNavigation2DConfig defaultNavigation2DConfig
         $ defaultConfig
    { borderWidth        = 1,
      terminal           = "urxvt",
      normalBorderColor  = "#000000",
      focusedBorderColor = "#9900cc",
      focusFollowsMouse  = False,
      workspaces         = map show [1..10],
      manageHook = manageDocks <+> manageHook defaultConfig,
      layoutHook = avoidStruts $ layoutHook defaultConfig,
      logHook = dynamicLogWithPP xmobarPP {
        ppOutput = hPutStrLn xmproc,
        ppTitle = xmobarColor "green" "" . shorten 50
      } >> myLogHook
    } `additionalKeys` ([
        ((mod1Mask,                 xK_Page_Down), sendMessage Shrink),
        ((mod1Mask,                 xK_Page_Up), sendMessage Expand),

        -- Switch between layers
        ((mod1Mask .|. controlMask,                 xK_space), switchLayer),

        -- Directional navigation of windows
        ((mod1Mask,                 xK_l), windowGo R False),
        ((mod1Mask,                 xK_h), windowGo L False),
        ((mod1Mask,                 xK_k), windowGo U False),
        ((mod1Mask,                 xK_j), windowGo D False),

        -- Swap adjacent windows
        ((mod1Mask .|. controlMask, xK_l), windowSwap R False),
        ((mod1Mask .|. controlMask, xK_h), windowSwap L False),
        ((mod1Mask .|. controlMask, xK_k), windowSwap U False),
        ((mod1Mask .|. controlMask, xK_j), windowSwap D False),

        -- Directional navigation of screens
        ((mod1Mask .|. shiftMask,                 xK_l    ), screenGo R False),
        ((mod1Mask .|. shiftMask,                 xK_h    ), screenGo L False),
        ((mod1Mask .|. shiftMask,                 xK_k    ), screenGo U False),
        ((mod1Mask .|. shiftMask,                 xK_j    ), screenGo D False),

        -- Swap workspaces on adjacent screens
        ((mod1Mask .|. controlMask .|. shiftMask, xK_l    ), screenSwap R False),
        ((mod1Mask .|. controlMask .|. shiftMask, xK_h    ), screenSwap L False),
        ((mod1Mask .|. controlMask .|. shiftMask, xK_k    ), screenSwap U False),
        ((mod1Mask .|. controlMask .|. shiftMask, xK_j    ), screenSwap D False),

        -- Send window to adjacent screen
        ((controlMask .|. shiftMask,    xK_l    ), windowToScreen R False),
        ((controlMask .|. shiftMask,    xK_h    ), windowToScreen L False),
        ((controlMask .|. shiftMask,    xK_k    ), windowToScreen U False),
        ((controlMask .|. shiftMask,    xK_j    ), windowToScreen D False),

        -- Audio control
        ((0, 0x1008ff11), spawn "amixer set Master 5-"),
        ((0, 0x1008ff13), spawn "amixer set Master 5+"),
        ((0, 0x1008ff12), spawn "amixer set Master toggle; amixer sset Headphone unmute; amixer sset Speaker unmute"),

        -- Watch cluster
        ((mod1Mask .|. shiftMask, xK_space), spawn "urxvt -e run watch head")
    ] ++ [((m .|. mod1Mask, k), windows (f i))
            | (i, k) <- zip (map show [1..10]) ([xK_1..xK_9] ++ [xK_0])
            , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]])
