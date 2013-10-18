import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
-- import XMonad.Actions.GridSelect
-- import XMonad.Layout.WindowNavigation
import XMonad.Actions.Navigation2D
import System.IO

main = do
  xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmobarrc"
  xmonad $ withNavigation2DConfig defaultNavigation2DConfig
         $ defaultConfig
    { borderWidth        = 3,
      terminal           = "urxvt",
      normalBorderColor  = "#000000",
      focusedBorderColor = "#ffcc00",
      manageHook = manageDocks <+> manageHook defaultConfig,
      layoutHook = avoidStruts  $  layoutHook defaultConfig,
      logHook = dynamicLogWithPP xmobarPP {
        ppOutput = hPutStrLn xmproc,
        ppTitle = xmobarColor "green" "" . shorten 50
      }
    } `additionalKeys` [
--      ((mod1Mask, xK_g), goToSelected defaultGSConfig)
--      ((mod1Mask, xK_h), sendMessage $ Go L),
--      ((mod1Mask, xK_l), sendMessage $ Go R),
--      ((mod1Mask, xK_k), sendMessage $ Go U),
--      ((mod1Mask, xK_j), sendMessage $ Go D),
--      ((mod1Mask .|. controlMask, xK_h), sendMessage $ Swap L),
--      ((mod1Mask .|. controlMask, xK_l), sendMessage $ Swap R),
--      ((mod1Mask .|. controlMask, xK_k), sendMessage $ Swap U),
--      ((mod1Mask .|. controlMask, xK_j), sendMessage $ Swap D),
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
        ((controlMask .|. shiftMask,    xK_j    ), windowToScreen D False)

    ]