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
# DIINSTALL BARU: p7zip-full, p7zip-rar, fastfetch, bleachbit,
#                 timeshift, fonts-noto
# DIUPDATE: cups (sudah ada di Ubuntu default sebagai sistem printing)
apt install -y \
    p7zip-full \
    p7zip-rar \
    cups \
    fastfetch \
    bleachbit \
    timeshift \
    fonts-noto

# -----------------------------------------------------------------------------
# 3. Multimedia & Office
# -----------------------------------------------------------------------------
# DIINSTALL BARU: ubuntu-restricted-extras, vlc, gimp, kdenlive,
#                 libreoffice, drawing
# DIUPDATE: libreoffice (sudah ada versi lama di Ubuntu default)
apt install -y \
    ubuntu-restricted-extras \
    vlc \
    gimp \
    kdenlive \
    libreoffice \
    drawing

# -----------------------------------------------------------------------------
# 4. Komunikasi & Hiburan — Spotify, Discord, Zoom, Chromium
# -----------------------------------------------------------------------------

# DIINSTALL BARU: spotify-client (via repository resmi)
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb https://repository.spotify.com stable non-free" | tee /etc/apt/sources.list.d/spotify.list
apt update
apt install -y spotify-client

# DIINSTALL BARU: discord (via .deb resmi)
wget -qO discord.deb "https://discord.com/api/download?platform=linux&format=deb"
dpkg -i discord.deb || apt --fix-broken install -y
rm discord.deb

# DIINSTALL BARU: zoom (via .deb resmi)
wget -qO zoom.deb "https://zoom.us/client/latest/zoom_amd64.deb"
dpkg -i zoom.deb || apt --fix-broken install -y
rm zoom.deb

# DIINSTALL BARU: chromium-browser
apt install -y chromium-browser

# -----------------------------------------------------------------------------
# 5. Programming — Python, JDK, NetBeans, VS Code
# -----------------------------------------------------------------------------

# DIUPDATE: python3 (sudah ada di Ubuntu default, diupdate ke versi terbaru)
# DIINSTALL BARU: python3-pip, python3-venv
apt install -y \
    python3 \
    python3-pip \
    python3-venv

# DIINSTALL BARU: default-jdk
apt install -y default-jdk

# DIINSTALL BARU: Apache NetBeans 29 (via .deb dari codelerity)
wget -qO netbeans.deb "https://github.com/codelerity/netbeans-packages/releases/download/v29-build1/apache-netbeans_29-1_amd64.deb"
dpkg -i netbeans.deb || apt --fix-broken install -y
rm netbeans.deb

# DIINSTALL BARU: Visual Studio Code (via .deb resmi Microsoft)
wget -qO vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
dpkg -i vscode.deb || apt --fix-broken install -y
rm vscode.deb

# -----------------------------------------------------------------------------
# 6. Wallpaper — Desktop, Lock screen
# -----------------------------------------------------------------------------

# DIGANTI: wallpaper desktop default Ubuntu (light & dark mode)
cp bground.png /usr/share/backgrounds/warty-final-ubuntu.png
cp bground.png /usr/share/backgrounds/ubuntu-wallpaper-d.png

# DIGANTI: wallpaper lock/login screen default Ubuntu
cp Lscreen.png /usr/share/backgrounds/ubuntu-default-greyscale-wallpaper.png

# -----------------------------------------------------------------------------
# 7. Boot Splash — Plymouth Kustom
# -----------------------------------------------------------------------------

# DIGANTI: watermark dan logo Plymouth spinner default Ubuntu
cp waltuhmark.png /usr/share/plymouth/themes/spinner/watermark.png
cp loco.png /usr/share/plymouth/themes/spinner/bgrt-fallback.png
update-initramfs -u

# -----------------------------------------------------------------------------
# 8. Cleanup
# -----------------------------------------------------------------------------
apt autoremove -y
apt clean
rm -rf /var/lib/apt/lists/*
