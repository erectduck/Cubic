#!/bin/bash
# =============================================================================
# Custom Ubuntu 25 Setup Script — via Cubic
# Dijalankan di dalam chroot environment Cubic
# =============================================================================

# Mencegah interaksi "Yes/No" selama instalasi
export DEBIAN_FRONTEND=noninteractive

# Pre-accept lisensi Microsoft Font untuk ubuntu-restricted-extras
echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections

# -----------------------------------------------------------------------------
# 1. Update Repositori
# -----------------------------------------------------------------------------
apt update
add-apt-repository universe -y
apt update

# -----------------------------------------------------------------------------
# 2. Utilitas Arsip, Printer & Ekstra
# -----------------------------------------------------------------------------
apt install -y \
    p7zip-full \
    p7zip-rar \
    cups \
    fastfetch \
    bleachbit \

# -----------------------------------------------------------------------------
# 3. Multimedia & Office
# -----------------------------------------------------------------------------
apt install -y \
    ubuntu-restricted-extras \
    vlc \
    gimp \
    libreoffice

# -----------------------------------------------------------------------------
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

# -----------------------------------------------------------------------------
# 5. Wallpaper — Desktop, Lock screen
# -----------------------------------------------------------------------------

# Desktop wallpaper (light & dark mode)
cp bground.png /usr/share/backgrounds/warty-final-ubuntu.png
cp bground.png /usr/share/backgrounds/ubuntu-wallpaper-d.png

# Lock/login screen
cp Lscreen.png /usr/share/backgrounds/ubuntu-default-greyscale-wallpaper.png

# -----------------------------------------------------------------------------
# 6. Boot Splash — Plymouth Kustom
# -----------------------------------------------------------------------------
cp waltuhmark.png /usr/share/plymouth/themes/spinner/watermark.png
cp loco.png /usr/share/plymouth/themes/spinner/bgrt-fallback.png
update-initramfs -u

# -----------------------------------------------------------------------------
# 7. Cleanup
# -----------------------------------------------------------------------------
apt autoremove -y
apt clean
rm -rf /var/lib/apt/lists/*
