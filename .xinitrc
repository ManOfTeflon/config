~/.screenlayout/triple.sh

xrdb -merge ~/.Xresources

xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'

xcompmgr &

trayer --edge top --align right --SetDockType true --SetPartialStrut true \
       --expand true --width 10 --transparent true --tint 0x191970 --height 12 &

xsetroot -solid midnightblue

nm-applet --sm-disable &
gnome-power-manager &

xsetroot -cursor_name left_ptr
exec xmonad
