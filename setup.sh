#!/bin/bash

# Mencegah interaksi "Yes/No" selama instalasi
export DEBIAN_FRONTEND=noninteractive

# 1. Update Repositori
# -----------------------------------------------------------------------------
apt update
add-apt-repository universe -y
apt update

# 2. Utilitas Arsip & Printer
# -----------------------------------------------------------------------------
apt install -y \
    p7zip-full \
    p7zip-rar \
    zip \
    unzip \
    cups \
    printer-driver-all

# 3. Multimedia & Office
# -----------------------------------------------------------------------------
apt install -y \
    vlc \
    libreoffice

# 4. Programming — Python, JDK, NetBeans, VS Code
# -----------------------------------------------------------------------------

# Python
apt install -y \
    python3 \
    python3-pip \
    python3-venv

# Java (JDK stable)
apt install -y default-jdk

# Apache NetBeans 21
wget -qO netbeans.deb "https://archive.apache.org/dist/netbeans/netbeans-installers/21/apache-netbeans_21-1_all.deb"
dpkg -i netbeans.deb || apt --fix-broken install -y
rm netbeans.deb

# Visual Studio Code
wget -qO vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
dpkg -i vscode.deb || apt --fix-broken install -y
rm vscode.deb

# 5. Tema Desktop — Orchis-Dark
# -----------------------------------------------------------------------------

# Ekstrak semua varian tema ke direktori sistem
tar -xf Orchis.tar.xz -C /usr/share/themes/

# Buat dconf profile agar settings terapply ke semua user baru
mkdir -p /etc/dconf/profile/
cat <<EOF > /etc/dconf/profile/user
user-db:user
system-db:local
EOF

# Terapkan Orchis-Dark sebagai tema GNOME default
mkdir -p /etc/dconf/db/local.d/
cat <<EOF > /etc/dconf/db/local.d/00-custom-settings
[org/gnome/desktop/interface]
gtk-theme='Orchis-Dark'
color-scheme='prefer-dark'
EOF

# Compile dconf database
dconf update

# 6. Boot Splash — Plymouth Kustom
# -----------------------------------------------------------------------------
cp waltuhmark.png /usr/share/plymouth/themes/spinner/watermark.png
cp logo.png /usr/share/plymouth/themes/spinner/bgrt-fallback.png
update-initramfs -u

# 7. Cleanup
# -----------------------------------------------------------------------------
apt autoremove -y
apt clean
rm -rf /var/lib/apt/lists/*
