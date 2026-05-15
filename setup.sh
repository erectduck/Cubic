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

# Install Gnome Tweaks dan User Theme extension
apt install -y \
    gnome-tweaks \
    gnome-shell-extension-user-theme

# Ekstrak tema GTK ke direktori sistem
tar -xf WhiteSur-Dark.tar.xz -C /usr/share/themes/

# Ekstrak icon theme ke direktori sistem
tar -xf 01-WhiteSur.tar.xz -C /usr/share/icons/

# Buat autostart script yang menerapkan tema saat user login pertama kali
cat <<'EOF' > /usr/local/bin/apply-whitesur-theme.sh
#!/bin/bash
# Tunggu GNOME Shell siap
sleep 3

# Aktifkan User Theme extension
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com

# Terapkan WhiteSur-Dark untuk GTK3, shell, icon, dan color scheme
gsettings set org.gnome.desktop.interface gtk-theme 'WhiteSur-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'WhiteSur-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.shell.extensions.user-theme name 'WhiteSur-Dark'

# Terapkan WhiteSur-Dark ke GTK4/libadwaita via symlink
mkdir -p ~/.config/gtk-4.0/
ln -sf /usr/share/themes/WhiteSur-Dark/gtk-4.0/gtk.css ~/.config/gtk-4.0/gtk.css
ln -sf /usr/share/themes/WhiteSur-Dark/gtk-4.0/gtk-dark.css ~/.config/gtk-4.0/gtk-dark.css

# Hapus autostart setelah tema terapply agar tidak jalan setiap login
rm -f ~/.config/autostart/apply-whitesur-theme.desktop
EOF
chmod +x /usr/local/bin/apply-whitesur-theme.sh

# Taruh autostart entry di skel agar terapply ke semua user baru
mkdir -p /etc/skel/.config/autostart/
cat <<'EOF' > /etc/skel/.config/autostart/apply-whitesur-theme.desktop
[Desktop Entry]
Type=Application
Name=Apply WhiteSur Theme
Exec=/usr/local/bin/apply-whitesur-theme.sh
X-GNOME-Autostart-enabled=true
EOF

# -----------------------------------------------------------------------------
# 6. Boot Splash — Plymouth Kustom
# -----------------------------------------------------------------------------
cp waltuhmark.png /usr/share/plymouth/themes/spinner/watermark.png
cp logo.png /usr/share/plymouth/themes/spinner/bgrt-fallback.png
update-initramfs -u

# -----------------------------------------------------------------------------
# 7. Cleanup
# -----------------------------------------------------------------------------
apt autoremove -y
apt clean
rm -rf /var/lib/apt/lists/*
