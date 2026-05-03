#!/bin/bash

# Mencegah interaksi "Yes/No"
export DEBIAN_FRONTEND=noninteractive

# 1. Update repositori
apt update

# 2. Utilitas, Jaringan, Printer, & Arsip
apt install -y p7zip-full p7zip-rar zip unzip
apt install -y cups printer-driver-all
apt install -y network-manager-gnome wireless-tools

# 3. Multimedia & Office (LibreOffice)
apt install -y vlc libreoffice

# 4. Programming (Python, Default JDK Stable, NetBeans)
apt install -y python3 python3-pip python3-venv
apt install -y default-jdk
apt install -y netbeans

# 5. Visual Studio Code (Via .deb langsung dari Microsoft)
wget -qO vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
dpkg -i vscode.deb || apt --fix-broken install -y
rm vscode.deb

# 6. Menerapkan Wallpaper 
cp wallpaper.jpg /usr/share/backgrounds/
mkdir -p /usr/share/glib-2.0/schemas/
cat <<EOF > /usr/share/glib-2.0/schemas/99-custom-settings.gschema.override
[org.gnome.desktop.background]
picture-uri='file:///usr/share/backgrounds/wallpaper.jpg'
picture-uri-dark='file:///usr/share/backgrounds/wallpaper.jpg'

[org.gnome.desktop.screensaver]
picture-uri='file:///usr/share/backgrounds/wallpaper.jpg'
EOF
glib-compile-schemas /usr/share/glib-2.0/schemas/

# 7. Menerapkan Logo Booting Kustom
cp logo-kustom.png /usr/share/plymouth/themes/spinner/watermark.png
cp logo-kustom.png /usr/share/plymouth/themes/spinner/bgrt-fallback.png
update-initramfs -u

# 8. Cleanup
apt autoremove -y
apt clean
rm -rf /var/lib/apt/lists/*
