#!/usr/bin/env bash
set -e

# Daftar paket yang disesuaikan untuk sistem berbasis Debian/Ubuntu/Linux Mint
PKGS_TO_INSTALL="build-essential git meson ninja-build valac libgee-0.8-dev libglib2.0-dev libwnck-3-dev libgtk-3-dev xterm python3 python3-setuptools libgnome-menu-3-dev plank xfce4-pulseaudio-plugin pulseaudio xfce4-appmenu-plugin vala-panel-appmenu appmenu-gtk2-module appmenu-gtk3-module"

run_cmd() {
    eval "$@"
}

rollback() {
    echo -e "\n\e[31m\e[1mError\e[0m: Terjadi kegagalan saat proses instalasi!"
    if [ -d "ventura-xfce" ]; then
        echo -e " ├── \e[31m[DELETING]\e[0m direktori kegagalan ventura-xfce..."
        rm -rf ventura-xfce
    fi
    echo -e " └── \e[33m\e[1mRemoving\e[0m paket apt yang terlanjur diinstal..."
    sudo apt-get remove -y --purge vala-panel-appmenu-xfce || true
}

apply_xfce_config() {
    echo -e " ├── \e[32m\e[1mFreezing\e[0m tugas XFCE aktif untuk imobilisasi berkas..."
    killall -9 xfce4-panel xfdesktop xfconfd 2>/dev/null || true
    pkill -9 -x xfce4-panel 2>/dev/null || true
    pkill -9 -x xfdesktop 2>/dev/null || true
    pkill -9 -x xfconfd 2>/dev/null || true
    sleep 0.5
    echo -e " │   ├── \e[31m[DELETING]\e[0m berkas lama ~/.config/xfce4..."
    rm -rf "$HOME/.config/xfce4"
    echo -e " │   ├── \e[31m[DELETING]\e[0m berkas lama ~/.config/xfce4-dict..."
    rm -rf "$HOME/.config/xfce4-dict"
    echo -e " │   ├── \e[34m[MOVING]\e[0m konfigurasi panel baru ke ~/.config/xfce4..."
    run_cmd "cp -rf '$BASE_DIR/ventura-xfce/config/xfce4/' ~/.config/"
    echo -e " │   └── \e[34m[MOVING]\e[0m konfigurasi dict baru ke ~/.config/xfce4-dict..."
    run_cmd "cp -rf '$BASE_DIR/ventura-xfce/config/xfce4-dict/' ~/.config/"
    echo -e " │   └── \e[34m[MOVING]\e[0m Keyboard Config"
    run_cmd "cp -rf '$BASE_DIR/keyboards.xml' ~/.config/xfce4/xfconf/xfce-perchannel-xml"
    echo -e " │   └── \e[34m[MOVING]\e[0m Keyboard Shortcut"
    run_cmd "cp -rf '$BASE_DIR/xfce4-keyboard-shortcuts.xml' ~/.config/xfce4/xfconf/xfce-perchannel-xml"
}

trap rollback ERR

echo -e "\e[34m.\e[0m"
echo -e "├── \e[32m\e[1mUpdating\e[0m indeks paket apt dan memasang dependensi..."
run_cmd "sudo apt-get update"
run_cmd "sudo apt-get install -y $PKGS_TO_INSTALL"

# Catatan: vala-panel-appmenu-xfce biasanya tidak ada di repo resmi Ubuntu/Mint, 
# jadi kita coba pasang secara opsional atau abaikan jika gagal
sudo apt-get install -y vala-panel-appmenu-xfce 2>/dev/null || echo -e "│   └── \e[33m[WARNING]\e[0m vala-panel-appmenu-xfce tidak ditemukan di repo, melewati..."

BASE_DIR="$PWD"

echo -e "├── \e[32m\e[1mExtracting\e[0m paket utama dari berkas ventura.tar.gz..."
run_cmd "tar -xf '$BASE_DIR/ventura.tar.gz' -C '$BASE_DIR'"
if [ -d "$BASE_DIR/ventura-xfce-main" ]; then
    echo -e "│   └── \e[34m[MOVING]\e[0m repositori ventura-xfce-main ke ventura-xfce..."
    run_cmd "mv '$BASE_DIR/ventura-xfce-main' '$BASE_DIR/ventura-xfce'"
fi

echo -e "├── \e[32m\e[1mBuilding\e[0m komponen utama eksternal Lightpad..."
run_cmd "cd '$BASE_DIR/ventura-xfce/lightpad'"
run_cmd "meson build --prefix=/usr --reconfigure >/dev/null"
run_cmd "cd build"
run_cmd "ninja >/dev/null"
echo -e "│   └── \e[32m\e[1mInstalling\e[0m eksternal binary Lightpad ke sistem..."
run_cmd "sudo ninja install >/dev/null"
run_cmd "cd '$BASE_DIR'"

echo -e "├── \e[32m\e[1mUnpacking\e[0m aset grafis (Tema, Ikon, Kursor, dan Launcher)..."
run_cmd "mkdir -p ~/.themes ~/.icons"
echo -e "│   ├── \e[32m[TAR]\e[0m Ekstraksi WhiteSur-Light ke ~/.themes..."
run_cmd "find '$BASE_DIR/ventura-xfce' -name 'WhiteSur-Light.tar.xz' -exec tar -xf {} -C ~/.themes/ \;"
echo -e "│   ├── \e[32m[TAR]\e[0m Ekstraksi WhiteSur-Dark ke ~/.themes..."
run_cmd "find '$BASE_DIR/ventura-xfce' -name 'WhiteSur-Dark.tar.xz' -exec tar -xf {} -C ~/.themes/ \;"
echo -e "│   ├── \e[32m[TAR]\e[0m Ekstraksi 01-WhiteSur ke ~/.icons..."
run_cmd "find '$BASE_DIR/ventura-xfce' -name '01-WhiteSur.tar.xz' -exec tar -xf {} -C ~/.icons/ \;"
echo -e "│   ├── \e[32m[TAR]\e[0m Ekstraksi custom ikon ke ~/.icons..."
run_cmd "find '$BASE_DIR/ventura-xfce' -name 'custom.tar.xz' -exec tar -xf {} -C ~/.icons/ \;"
echo -e "│   ├── \e[32m[TAR]\e[0m Ekstraksi WhiteSur-cursors ke ~/.icons..."
run_cmd "find '$BASE_DIR/ventura-xfce' -name 'WhiteSur-cursors.tar.xz' -exec tar -xf {} -C ~/.icons/ \; 2>/dev/null || true"

run_cmd "mkdir -p ~/.launchers"
echo -e "│   ├── \e[31m[DELETING]\e[0m launcher lama di ~/.launchers/*..."
run_cmd "rm -rf ~/.launchers/*"
echo -e "│   ├── \e[34m[MOVING]\e[0m launcher dock baru ke ~/.launchers..."
run_cmd "cp -rf '$BASE_DIR/ventura-xfce/dock/launchers/'* ~/.launchers/"
run_cmd "cd ~/.launchers/ && sed -i 's/ibm-7094/'$USER'/g' * && cd -"

echo -e "├── \e[32m\e[1mConfiguring\e[0m visibilitas komponen utama Plank Dock..."
mkdir -p ~/.config/plank/dock1/launchers
echo -e "│   ├── \e[31m[DELETING]\e[0m launcher plank lama di ~/.config/plank/dock1/launchers/*..."
run_cmd "rm -rf ~/.config/plank/dock1/launchers/*"
echo -e "│   ├── \e[34m[MOVING]\e[0m sinkronisasi berkas launcher baru ke susunan Plank..."
cp -rf ~/.launchers/* ~/.config/plank/dock1/launchers/

mkdir -p ~/.config/plank/dock1
if [ -f ~/.config/plank/dock1/settings ]; then
    sed -i 's/Theme=.*/Theme=Transparent/g' ~/.config/plank/dock1/settings
else
    echo "Theme=Transparent" >~/.config/plank/dock1/settings
fi

mkdir -p ~/.config/autostart
cat <<EOF >~/.config/autostart/plank.desktop
[Desktop Entry]
Type=Application
Exec=plank
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Plank
Comment=Dock minimalis bergaya macOS
EOF

if [ -d "$HOME/.config/xfce4" ]; then
    echo -e "├── \e[33m\e[1mWarning\e[0m: Folder konfigurasi XFCE sudah ada di ~/.config/xfce4"
    read -p "│         Apakah Anda ingin menimpa (replace) konfigurasi tersebut? (y/N): " choice
    case "$choice" in
    y | Y)
        apply_xfce_config
        apply_xfce_config
        apply_xfce_config
        apply_xfce_config
        apply_xfce_config
        apply_xfce_config
        apply_xfce_config
        ;;
    *)
        echo -e "│   └── \e[32m\e[1mSkipping\e[0m konfigurasi ~/.config/xfce4 Anda aman."
        ;;
    esac
else
    echo -e "├── \e[32m\e[1mCreating\e[0m berkas konfigurasi lingkungan desktop baru..."
    run_cmd "mkdir -p ~/.config"
    apply_xfce_config
fi

run_cmd "mkdir -p ~/.wallpapers"
echo -e "├── \e[34m[MOVING]\e[0m menyalin seluruh berkas wallpaper ke ~/.wallpapers..."
run_cmd "cp -rf ventura-xfce/wallpapers/* ~/.wallpapers/"

WALLPAPER_TARGET="$HOME/.wallpapers/ventura-dark.jpg"
echo -e "├── \e[32m\e[1mTargeting\e[0m berkas latar belakang pada engine xfconf..."
OLD_PROPS=$(xfconf-query -c xfce4-desktop -l | grep -E 'last-image|image-path' || true)
for PROP in $OLD_PROPS; do
    xfconf-query -c xfce4-desktop -p "$PROP" -r 2>/dev/null || true
done
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image --create -t string -s "$WALLPAPER_TARGET" 2>/dev/null || xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s "$WALLPAPER_TARGET"
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorHDMI-1/workspace0/last-image --create -t string -s "$WALLPAPER_TARGET" 2>/dev/null || xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorHDMI-1/workspace0/last-image -s "$WALLPAPER_TARGET"
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/image-style --create -t int -s 5 2>/dev/null || xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/image-style -s 5
killall xfdesktop 2>/dev/null || true
nohup xfdesktop >/dev/null 2>&1 &

echo -e "├── \e[32m\e[1mApplying\e[0m skema warna tema WhiteSur-Dark dan properti xfwm4..."
xfconf-query -c xsettings -p /Net/ThemeName --create -t string -s "WhiteSur-Dark" || xfconf-query -c xsettings -p /Net/ThemeName -s "WhiteSur-Dark"
xfconf-query -c xfwm4 -p /general/theme --create -t string -s "WhiteSur-Dark" || xfconf-query -c xfwm4 -p /general/theme -s "WhiteSur-Dark"
xfconf-query -c xfwm4 -p /general/button_layout --create -t string -s "CHM" || xfconf-query -c xfwm4 -p /general/button_layout -s "CHM"
xfconf-query -c xfwm4 -p /general/use_compositing --create -t bool -s true || xfconf-query -c xfwm4 -p /general/use_compositing -s true
xfconf-query -c xfwm4 -p /general/box_size --create -t int -s 4 || true
xfconf-query -c xfce4-panel -p /panels/panel-1/background-alpha --create -t int -s 0 || xfconf-query -c xfce4-panel -p /panels/panel-1/background-alpha -s 0 2>/dev/null || true
xfconf-query -c xfce4-panel -p /panels/panel-1/background-style --create -t int -s 0 || xfconf-query -c xfce4-panel -p /panels/panel-1/background-style -s 0 2>/dev/null || true

echo -e "├── \e[32m\e[1mCleaning\e[0m menghapus direktori kerja source code..."
echo -e "│   └── \e[31m[DELETING]\e[0m pembersihan permanen folder temp di $BASE_DIR/ventura-xfce..."
run_cmd "rm -rf '$BASE_DIR/ventura-xfce'"

echo -e "└── \e[32m\e[1mReloading\e[0m daemon xfconfd dan memuat ulang panel disk..."
/usr/lib/x86_64-linux-gnu/xfce4/xfconf/xfconfd &
sleep 0.2
(xfce4-panel >/dev/null 2>&1 &)
(xfdesktop >/dev/null 2>&1 &)

trap - ERR
echo -e "\n    \e[32m\e[1mFinished\e[0m Ventura-Xfce target(s) dalam tahapan bersih."
echo -e "\nSilakan \e[1mLOGOUT\e[22m lalu \e[1mLOGIN\e[22m kembali untuk melihat perubahan desktop secara optimal."

