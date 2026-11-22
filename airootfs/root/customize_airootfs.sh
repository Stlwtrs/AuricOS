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

# Live session user. LightDM logs it in automatically (lightdm.conf.d/50-auricos-live.conf).
# Its password is locked: autologin doesn't need one, and nobody can log in as it remotely.
# The installer deletes this user and every file below (shellprocess_cleanup.conf).
groupadd -rf autologin
useradd -m -u 1000 -c "AuricOS Live" -G wheel,autologin,audio,video,storage -s /usr/bin/zsh auric
passwd -l auric

# Passwordless sudo for the live user only
printf 'auric ALL=(ALL:ALL) NOPASSWD: ALL\n' > /etc/sudoers.d/99-auricos-live
chmod 440 /etc/sudoers.d/99-auricos-live

# Let the live user start the installer (pkexec) without a password prompt
cat > /etc/polkit-1/rules.d/49-auricos-live.rules <<'RULES'
// Live session only. The installer deletes this file.
polkit.addRule(function (action, subject) {
    if (subject.user == "auric" && subject.local && subject.active) {
        return polkit.Result.YES;
    }
});
RULES
