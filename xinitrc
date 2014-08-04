#exec openbox-session

#xcompmgr &                                  #-Cc & # transparency, fading etc.
# xset -b &                                   # turn off system bell
# killall mpdscribble; mpdscribble &          # scrobble to last.fm
# xbindkeys -f ~/.xbindkeysrc &               # keyboard shortcuts and volume controls
# unclutter &                                 # removes mouse cursor after inactivity
# xsetroot -cursor_name left_ptr              # xmonad cursor


#gnome-settings-daemon # handles themes, starts gnome-screensaver

# xmodmap ~/.xmodmaprc &

# (sleep 5 && urxvt -e ssh-add) &             # ssh passphrase agent
#(sleep 5 && urxvt -e StartHFSDaemon) &      # hfs backup utility
# (sleep 5 && xmodmap /home/rjs/.xmodmaprc) & # caps lock -> escape, and hash key stuff

#urxvtd -q -f -o
xset r rate 250 100                      & # keyboard repeat rate

xmodmap ~/.xmodmaprc &

#/home/rjs/bin/slimlock &                    # lock 'er up

setxkbmap -option terminate:ctrl_alt_bksp &    # ctrl-alt-bksp to terminate Xorg
exec xmonad                                # start Xmonad
