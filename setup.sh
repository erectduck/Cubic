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
# 4. Komunikasi & Hiburan — Discord, Zoom, Chromium
# -----------------------------------------------------------------------------

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

# DIUPDATE: python3 (sudah ada di Ubuntu default)
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
# 6. Web Server — Apache, PHP, MySQL, SSL, SSH, Monitoring
# -----------------------------------------------------------------------------
#
# PANDUAN PENGOPERASIAN:
# ======================
# Semua service TIDAK berjalan otomatis saat boot.
# Jalankan manual sesuai kebutuhan:
#
# 1. Menjalankan service:
#    sudo systemctl start apache2
#    sudo systemctl start mysql
#    sudo systemctl start ssh
#
# 2. Menghentikan service:
#    sudo systemctl stop apache2
#    sudo systemctl stop mysql
#    sudo systemctl stop ssh
#
# 3. Mengaktifkan firewall (jalankan sekali setelah install):
#    sudo ufw enable
#    sudo ufw status        ← cek status firewall
#
# 4. Mendapatkan sertifikat SSL (butuh domain publik):
#    sudo systemctl start apache2
#    sudo certbot --apache
#
# 5. Monitoring sistem:
#    htop                   ← monitor CPU, RAM, proses
#    sudo netstat -tuln     ← cek port yang aktif
#    sudo iftop             ← monitor traffic jaringan realtime
#
# 6. Lokasi file web:
#    /var/www/html/         ← taruh file website di sini
#
# 7. Konfigurasi Apache:
#    /etc/apache2/          ← folder konfigurasi Apache
#
# 8. Konfigurasi MySQL:
#    sudo mysql -u root     ← masuk ke MySQL shell
# =============================================================================

# DIINSTALL BARU: Apache web server
apt install -y apache2

# DIINSTALL BARU: PHP dan modul umum (ikut versi default Ubuntu 25)
apt install -y \
    php \
    php-mysql \
    php-curl \
    php-gd \
    php-mbstring \
    php-xml \
    php-zip \
    libapache2-mod-php

# DIINSTALL BARU: MySQL server dan client
apt install -y \
    mysql-server \
    mysql-client

# DIINSTALL BARU: OpenSSH server untuk remote access
apt install -y openssh-server

# DIINSTALL BARU: UFW firewall dan konfigurasi rule dasar
apt install -y ufw
ufw allow OpenSSH    # izinkan SSH (port 22)
ufw allow 'Apache Full'  # izinkan HTTP (80) dan HTTPS (443)
# CATATAN: ufw enable tidak dijalankan di sini
#          Aktifkan manual dengan: sudo ufw enable

# DIINSTALL BARU: Certbot untuk sertifikat SSL (Let's Encrypt)
apt install -y \
    certbot \
    python3-certbot-apache

# DIINSTALL BARU: Monitoring tools
# htop    → monitor CPU, RAM, dan proses secara interaktif
# net-tools → menyediakan netstat untuk cek koneksi dan port
# iftop   → monitor traffic jaringan realtime per koneksi
apt install -y \
    htop \
    net-tools \
    iftop

# Semua service diset disable — tidak berjalan otomatis saat boot
systemctl disable apache2
systemctl disable mysql
systemctl disable ssh

# -----------------------------------------------------------------------------
# 7. Wallpaper — Desktop, Lock screen
# -----------------------------------------------------------------------------

# DIGANTI: wallpaper desktop default Ubuntu (light & dark mode)
cp bground.png /usr/share/backgrounds/warty-final-ubuntu.png
cp bground.png /usr/share/backgrounds/ubuntu-wallpaper-d.png

# DIGANTI: wallpaper lock/login screen default Ubuntu
cp Lscreen.png /usr/share/backgrounds/ubuntu-default-greyscale-wallpaper.png

# -----------------------------------------------------------------------------
# 8. Boot Splash — Plymouth Kustom
# -----------------------------------------------------------------------------

# DIGANTI: watermark dan logo Plymouth spinner default Ubuntu
cp waltuhmark.png /usr/share/plymouth/themes/spinner/watermark.png
cp loco.png /usr/share/plymouth/themes/spinner/bgrt-fallback.png
update-initramfs -u

# -----------------------------------------------------------------------------
# 9. Cleanup
# -----------------------------------------------------------------------------
apt autoremove -y
apt clean
rm -rf /var/lib/apt/lists/*
