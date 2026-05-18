#!/bin/bash
# =============================================================================
# Custom Ubuntu 25 Setup Script — via Cubic
# Dijalankan di dalam chroot environment Cubic
# =============================================================================

# Mencegah interaksi "Yes/No" selama instalasi
export DEBIAN_FRONTEND=noninteractive

# -----------------------------------------------------------------------------
# 1. Update Repositori
# -----------------------------------------------------------------------------
apt update
add-apt-repository universe -y
apt update

# -----------------------------------------------------------------------------
# 2. Utilitas Arsip & Printer
# -----------------------------------------------------------------------------
apt install -y \
    p7zip-full \
    p7zip-rar \
    zip \
    unzip \
    cups \
    printer-driver-all

# -----------------------------------------------------------------------------
# 3. Multimedia & Office
# -----------------------------------------------------------------------------
apt install -y \
    vlc \
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
# 5. Tema Desktop — WhiteSur-Dark
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# 6. Boot Splash — Plymouth Kustom
# -----------------------------------------------------------------------------
cp gi.png /usr/share/plymouth/themes/spinner/watermark.png
cp yo.png /usr/share/plymouth/themes/spinner/bgrt-fallback.png
update-initramfs -u

# -----------------------------------------------------------------------------
# 7. Cleanup
# -----------------------------------------------------------------------------
apt autoremove -y
apt clean
rm -rf /var/lib/apt/lists/*
