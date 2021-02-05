#!/usr/bin/env bash

# Bluetooth
rfkill unblock all
systemctl enable bluetooth


# firewalld
if installedpkg firewalld; then
    systemctl enable firewalld.service
fi


# Added autologin group to auto login
groupadd autologin
usermod -aG autologin ${username}


# ntp
systemctl enable systemd-timesyncd.service


# Enable LightDM to auto login
if [[ "${boot_splash}" =  true ]]; then
    systemctl enable lightdm-plymouth.service
else
    systemctl enable lightdm.service
fi


# Set script permission
chmod 755 /usr/bin/alterlinux-gtk-bookmarks

# Replace auto login user
sed -i s/%USERNAME%/${username}/g /etc/lightdm/lightdm.conf

# Replace password for screensaver comment
sed -i s/%PASSWORD%/${password}/g "/etc/dconf/db/local.d/02-disable-lock"

# Update system datebase
dconf update

# Remove shortcut for alterlinux-welcome-page
remove "/usr/share/alterlinux/desktop-file/welcome-to-alter.desktop"

# Replace wallpaper.
if [[ -f /usr/share/backgrounds/xfce/xfce-verticals.png ]]; then
    remove /usr/share/backgrounds/xfce/xfce-verticals.png
    ln -s /usr/share/backgrounds/Aqua.jpg /usr/share/backgrounds/xfce/xfce-verticals.png
fi
[[ -f /usr/share/backgrounds/Aqua.jpg ]] && chmod 644 /usr/share/backgrounds/Aqua.jpg

# Replace lightDM
rm -f -r /usr/share/lightdm-webkit/themes/alter/images/4-3.png
rm -f -r /usr/share/lightdm-webkit/themes/alter/images/5-4.png
rm -f -r /usr/share/lightdm-webkit/themes/alter/images/16-9.png
rm -f -r /usr/share/lightdm-webkit/themes/alter/images/16-10.png
rm -f -r /usr/share/lightdm-webkit/themes/alter/images/Aqua_logo.png
rm -f -r /usr/share/lightdm-webkit/themes/alter/images/index.html
cp -f /usr/share/backgrounds/4-3.png /usr/share/lightdm-webkit/themes/alter/images/4-3.png
cp -f /usr/share/backgrounds/5-4.png /usr/share/lightdm-webkit/themes/alter/images/5-4.png
cp -f /usr/share/backgrounds/16-9.png /usr/share/lightdm-webkit/themes/alter/images/16-9.png
cp -f /usr/share/backgrounds/16-10.png /usr/share/lightdm-webkit/themes/alter/images/16-10.png
cp -f /usr/share/backgrounds/os.png /usr/share/lightdm-webkit/themes/alter/images/Aqua_logo.png
cp -f /usr/share/backgrounds/index.html /usr/share/lightdm-webkit/themes/alter/index.html
