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

# 5. Tema Desktop — Graphite Dark
# -----------------------------------------------------------------------------

# Install dependency tema Graphite
apt install -y \
    gtk2-engines-murrine \
    sassc \
    git

# Clone repo Graphite (official dari vinceliuice)
git clone --depth=1 https://github.com/vinceliuice/Graphite-gtk-theme.git /tmp/Graphite-theme

# Install varian dark ke system-wide + aktifkan libadwaita support
# Flag: -d system-wide, -c dark, -l libadwaita link
/tmp/Graphite-theme/install.sh \
    -d /usr/share/themes \
    -c dark \
    -l

# Flag -l menulis gtk-4.0 config ke $HOME/.config/gtk-4.0 (yaitu /root/ di chroot)
# Copy ke /etc/skel agar terapply ke semua user baru (hanya gtk-4.0, aman untuk installer)
mkdir -p /etc/skel/.config/
cp -r /root/.config/gtk-4.0 /etc/skel/.config/gtk-4.0

# Bersihkan repo
rm -rf /tmp/Graphite-theme

# Terapkan Graphite-Dark sebagai tema default via gschema override (cara resmi Cubic)
mkdir -p /usr/share/glib-2.0/schemas/
cat <<EOF > /usr/share/glib-2.0/schemas/99_custom-theme.gschema.override
[org.gnome.desktop.interface]
gtk-theme='Graphite-Dark'
color-scheme='prefer-dark'
EOF

# Compile schema
glib-compile-schemas /usr/share/glib-2.0/schemas/

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
