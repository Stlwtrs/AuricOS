#!/bin/bash

# Import and trust the CachyOS signing key inside the ISO before any other command
pacman-key --init
pacman-key --recv-keys F3B607488DB35A47 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key F3B607488DB35A47

# 1. Enable LightDM [the login manager]
systemctl enable dbus
systemctl enable lightdm

# 2. Remove the default Arch Linux issue text entirely
rm -f /etc/issue
rm -f /etc/issue.net

# 3. Copy the custom logo for the login screen so it shows on launch
if [ -f /usr/share/auricos/AURIC.svg ];
then
    cp /usr/share/auricos/AURIC.svg /usr/share/pixmaps/archlinux-logo-text.svg
fi

# 4. Fix LightDM permissions
groupadd -f video
groupadd -f input
usermod -aG video,input root
rm -f /tmp/.X0-lock

# Force the wallpaper before XFCE starts up
echo "feh --bg-fill /usr/share/backgrounds/auricos/login.png" >> /root/.xinitrc

# Fix Fastfetch Branding
# Renaming the Real Binary
mv /usr/bin/fastfetch /usr/bin/fastfetch-bin
# Copy custom script to take its place
cp /usr/local/bin/fastfetch /usr/bin/fastfetch
chmod +x /usr/bin/fastfetch

# Create directories for the live root user
mkdir -p /root/Desktop /root/Documents /root/Downloads /root/Music /root/Pictures /root/Videos /root/Public /root/Templates

# Open Dolphin on file open
xdg-mime default org.kde.dolphin.desktop inode/directory
