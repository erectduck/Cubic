#!/bin/bash

# Mencegah interaksi "Yes/No"
export DEBIAN_FRONTEND=noninteractive

# 1. Update repositori dan pastikan repositori 'universe' aktif
apt update
add-apt-repository universe -y
apt update

# 2. Utilitas, Jaringan, Printer, & Arsip
apt install -y p7zip-full p7zip-rar zip unzip
apt install -y cups printer-driver-all
# Mengganti wireless-tools dengan paket jaringan modern
#apt install -y network-manager-gnome iw wpasupplicant

# 3. Multimedia & Office (LibreOffice)
apt install -y vlc libreoffice

# 4. Programming (Python, Default JDK Stable, NetBeans)
#apt install -y python3 python3-pip python3-venv
#apt install -y default-jdk
# Unduh dan Install Apache NetBeans secara langsung
wget -qO netbeans.deb "https://archive.apache.org/dist/netbeans/netbeans-installers/21/apache-netbeans_21-1_all.deb"
dpkg -i netbeans.deb || apt --fix-broken install -y
rm netbeans.deb

# 5. Visual Studio Code (Via .deb langsung dari Microsoft)
wget -qO vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
dpkg -i vscode.deb || apt --fix-broken install -y
rm vscode.deb

# 6. Menerapkan Wallpaper Desktop dan Layar Kunci (Login/Sleep)
#cp wallpaper.png /usr/share/backgrounds/
#cp login.png /usr/share/backgrounds/
#mkdir -p /usr/share/glib-2.0/schemas/
#cat <<EOF > /usr/share/glib-2.0/schemas/99-custom-settings.gschema.override
#[org.gnome.desktop.background]
#picture-uri='file:///usr/share/backgrounds/wallpaper.png'
#picture-uri-dark='file:///usr/share/backgrounds/wallpaper.png'

#[org.gnome.desktop.screensaver]
#picture-uri='file:///usr/share/backgrounds/login.png'
#picture-uri-dark='file:///usr/share/backgrounds/login.png'
#EOF
#glib-compile-schemas /usr/share/glib-2.0/schemas/

# 6. Mengubah Tema GTK (Ekstrak dari file tar.xz)
# Buat folder penampungan tema jika belum ada
mkdir -p /usr/share/themes

# Ekstrak file mentah tema langsung ke direktori sistem
# PENTING: Ganti "nama-file-tema.tar.xz" dengan nama file asli yang kamu upload ke GitHub
tar -xf Orchis.tar.xz -C /usr/share/themes/

# Terapkan tema varian Orchis-Dark dan aktifkan mode gelap
mkdir -p /usr/share/glib-2.0/schemas/
cat <<EOF > /usr/share/glib-2.0/schemas/99-custom-theme.gschema.override
[org.gnome.desktop.interface]
gtk-theme='Orchis-Dark'
color-scheme='prefer-dark'
EOF
glib-compile-schemas /usr/share/glib-2.0/schemas/

# 7. Menerapkan Logo Booting Kustom
cp waltuhmark.png /usr/share/plymouth/themes/spinner/watermark.png
cp logo.png /usr/share/plymouth/themes/spinner/bgrt-fallback.png
update-initramfs -u

# 8. Cleanup
apt autoremove -y
apt clean
rm -rf /var/lib/apt/lists/*
