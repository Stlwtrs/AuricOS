#!/bin/bash
# Wait up to 20s for the XFCE daemon(s)
for i in $(seq 1 20); do
    pgrep -x xfsettingsd >/dev/null && pgrep -x xfdesktop >/dev/null && break
    sleep 1
done

set_str() { xfconf-query -c xsettings -p "$1" -n -t string -s "$2"; }
set_str /Net/ThemeName "Adwaita-dark"
set_str /Net/IconThemeName "Papirus-Dark"
set_str /Gtk/FontName "Inter 10"
set_str /Gtk/MonospaceFontName "JetBrains Mono 10"

# Disable XFCE compositing
xfconf-query -c xfwm4 -p /general/use_compositing -s false

# Start Picom Compositor
picom -b --config /root/.config/picom/picom.conf

# Force desktop icons to open Dolphin as a default
xfconf-query -c xfce4-desktop -p /desktop-icons/default-file-manager -n -t string -s "dolphin"

# Hide desktop icons
pacman -Qs xfce4-desktop
for i in {1..10}; do
    if xfconf-query -c xfce4-desktop -l 2>/dev/null | grep -q desktop-icons; then
        break
    fi
    sleep 0.5
done
xfconf-query -c xfce4-desktop -p /desktop-icons/style -n -t int -s 0
