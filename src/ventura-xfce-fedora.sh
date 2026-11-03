#!/usr/bin/env bash
set -e
DRY_RUN=false
DEBUG_MODE=false
for arg in "$@"; do
	if [ "$arg" = "--dry-run" ] || [ "$arg" = "-d" ]; then
		DRY_RUN=true
	elif [ "$arg" = "--debug" ]; then
		DEBUG_MODE=true
	fi
done

# Daftar dependensi resmi Fedora (main-category sudah DIBERSIHKAN)
PKGS_TO_INSTALL="git meson ninja-build vala libgee-devel gnome-menus-devel glib2-devel libwnck3-devel gtk3-devel xterm python3 python3-setuptools gnome-menus plank pulseaudio-utils gcc gcc-c++ xfce4-panel-devel"

run_cmd() {
	if [ "$DRY_RUN" = true ]; then
		echo -e "\e[33m[DRY-RUN SIMULASI] $*\e[0m"
	else
		echo -e "\e[32m[MENJALANKAN] $*\e[0m"
		eval "$@"
	fi
}

rollback() {
	echo -e "\n\e[31m[ERROR] Terjadi kegagalan saat proses instalasi!\e[0m"
	if [ "$DRY_RUN" = false ]; then
		if [ "$DEBUG_MODE" = false ] && [ -d "ventura-xfce" ]; then
			rm -rf ventura-xfce
		fi
		echo -e "\e[31m[ROLLBACK] Menghapus paket dnf yang terlanjur diinstal...\e[0m"
		sudo dnf remove -y $PKGS_TO_INSTALL || true
	fi
}

apply_xfce_config() {
	echo -e "\e[32m[MENYALIN] Mematikan paksa tugas XFCE untuk membekukan konfigurasi...\e[0m"
	if [ "$DRY_RUN" = false ]; then
		killall -9 xfce4-panel xfdesktop xfconfd 2>/dev/null || true
		pkill -9 -x xfce4-panel 2>/dev/null || true
		pkill -9 -x xfdesktop 2>/dev/null || true
		pkill -9 -x xfconfd 2>/dev/null || true
		sleep 0.5
		rm -rf "$HOME/.config/xfce4"
		rm -rf "$HOME/.config/xfce4-dict"
	fi
	run_cmd "cp -rf '$BASE_DIR/ventura-xfce/config/xfce4/' ~/.config/"
	run_cmd "cp -rf '$BASE_DIR/ventura-xfce/config/xfce4-dict/' ~/.config/"
}

trap rollback ERR
echo "=================================================="
if [ "$DRY_RUN" = true ]; then
	echo " MODE DRY-RUN AKTIF: Simulasi tanpa mengubah sistem."
elif [ "$DEBUG_MODE" = true ]; then
	echo " MODE DEBUG AKTIF: Menggunakan source lokal jika sudah ada."
else
	echo " Memulai Instalasi Ventura-Xfce di Fedora Linux..."
fi
echo "=================================================="

# 1. Instalasi paket dasar dan kakas kompilasi dari repositori resmi Fedora
run_cmd "sudo dnf install -y $PKGS_TO_INSTALL"

BASE_DIR="$PWD"
if [ -d "$BASE_DIR/ventura-xfce" ]; then
	if [ "$DEBUG_MODE" = true ]; then
		echo -e "\e[36m[DEBUG] Repositori lokal ditemukan di $BASE_DIR/ventura-xfce. Kloning dilewati.\e[0m"
	else
		echo -e "\e[33m[SINKRONISASI] Repositori lama ditemukan. Memperbarui bersih...\e[0m"
		run_cmd "rm -rf '$BASE_DIR/ventura-xfce'"
		run_cmd "git clone --depth 1 https://github.com/ibm-7094a/ventura-xfce '$BASE_DIR/ventura-xfce'"
	fi
else
	echo -e "\e[32m[GIT] Mengunduh repositori ventura-xfce baru...\e[0m"
	run_cmd "git clone --depth 1 https://github.com/ibm-7094a/ventura-xfce '$BASE_DIR/ventura-xfce'"
fi

# 2. Kompilasi dan Pemasangan xfce4-appmenu-plugin dari repositori hulu
echo -e "\e[32m[KOMPILASI] Membangun xfce4-appmenu-plugin dari source code hulu...\e[0m"
if [ ! -d "$BASE_DIR/xfce4-appmenu-plugin" ]; then
	run_cmd "git clone --depth 1 https://github.com/rilian-la-te/vala-panel-appmenu '$BASE_DIR/xfce4-appmenu-plugin'"
fi
run_cmd "cd '$BASE_DIR/xfce4-appmenu-plugin'"
run_cmd "meson build --prefix=/usr --reconfigure"
run_cmd "cd build"
run_cmd "ninja"
run_cmd "sudo ninja install"
run_cmd "cd '$BASE_DIR'"
if [ "$DEBUG_MODE" = false ]; then
	run_cmd "rm -rf '$BASE_DIR/xfce4-appmenu-plugin'"
fi

# 3. Kompilasi Lightpad
run_cmd "cd '$BASE_DIR/ventura-xfce/lightpad'"
run_cmd "meson build --prefix=/usr --reconfigure"
run_cmd "cd build"
run_cmd "ninja"
run_cmd "sudo ninja install"
run_cmd "cd '$BASE_DIR'"

run_cmd "mkdir -p ~/.themes ~/.icons"
run_cmd "find '$BASE_DIR/ventura-xfce' -name 'WhiteSur-Light.tar.xz' -exec tar -xf {} -C ~/.themes/ \;"
run_cmd "find '$BASE_DIR/ventura-xfce' -name 'WhiteSur-Dark.tar.xz' -exec tar -xf {} -C ~/.themes/ \;"
run_cmd "find '$BASE_DIR/ventura-xfce' -name '01-WhiteSur.tar.xz' -exec tar -xf {} -C ~/.icons/ \;"
run_cmd "find '$BASE_DIR/ventura-xfce' -name 'custom.tar.xz' -exec tar -xf {} -C ~/.icons/ \;"
run_cmd "find '$BASE_DIR/ventura-xfce' -name 'WhiteSur-cursors.tar.xz' -exec tar -xf {} -C ~/.icons/ \; 2>/dev/null || true"

run_cmd "mkdir -p ~/.launchers"
run_cmd "rm -rf ~/.launchers/*"
run_cmd "cp -rf '$BASE_DIR/ventura-xfce/dock/launchers/'* ~/.launchers/"
run_cmd "cd ~/.launchers/ && sed -i 's/ibm-7094/'$USER'/g' * && cd -"

if [ "$DRY_RUN" = false ]; then
	echo -e "\e[32m[OTOMATIS] Memasukkan ikon langsung ke dalam konfigurasi Plank Dock...\e[0m"
	mkdir -p ~/.config/plank/dock1/launchers
	rm -rf ~/.config/plank/dock1/launchers/*
	cp -rf ~/.launchers/* ~/.config/plank/dock1/launchers/
	echo -e "\e[32m[OTOMATIS] Mengatur Plank Dock agar transparan...\e[0m"
	mkdir -p ~/.config/plank/dock1
	if [ -f ~/.config/plank/dock1/settings ]; then
		sed -i 's/Theme=.*/Theme=Transparent/g' ~/.config/plank/dock1/settings
	else
		echo "Theme=Transparent" >~/.config/plank/dock1/settings
	fi
	echo -e "\e[32m[OTOMATIS] Mendaftarkan Plank ke Startup Aplikasi (Autostart)...\e[0m"
	mkdir -p ~/.config/autostart
	cat <<EOF >~/.config/autostart/plank.desktop
[Desktop Entry]
Type=Application
Exec=sh -c "sleep 2 && plank"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
X-XFCE-Autostart-enabled=true
OnlyShowIn=XFCE;GNOME;
Name=Plank
Comment=Dock minimalis bergaya macOS
EOF
	chmod +x ~/.config/autostart/plank.desktop
fi

if [ -d "$HOME/.config/xfce4" ]; then
	echo -e "\e[35m[PERHATIAN] Folder konfigurasi XFCE sudah ada di ~/.config/xfce4\e[0m"
	read -p "Apakah Anda ingin menimpa (replace) konfigurasi tersebut? (y/N): " choice
	case "$choice" in
	y | Y)
		apply_xfce_config
		apply_xfce_config
		apply_xfce_config
		apply_xfce_config
		;;
	*)
		echo -e "\e[33m[DILEWATI] Konfigurasi ~/.config/xfce4 Anda aman.\e[0m"
		;;
	esac
else
	echo -e "\e[32m[OTOMATIS] Folder config belum ada, menyalin konfigurasi baru...\e[0m"
	run_cmd "mkdir -p ~/.config"
	apply_xfce_config
fi

run_cmd "mkdir -p ~/.wallpapers"
run_cmd "cp -rf ventura-xfce/wallpapers/* ~/.wallpapers/"

if [ "$DRY_RUN" = false ]; then
	WALLPAPER_TARGET="/home/$USER/.wallpapers/ventura-dark.jpg"
	echo -e "\e[32m[OTOMATIS] Mengonfigurasi pure XFCE desktop background...\e[0m"
	OLD_PROPS=$(xfconf-query -c xfce4-desktop -l | grep -E 'last-image|image-path' || true)
	for PROP in $OLD_PROPS; do
		xfconf-query -c xfce4-desktop -p "$PROP" -r 2>/dev/null || true
	done
	xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image --create -t string -s "$WALLPAPER_TARGET" 2>/dev/null || xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s "$WALLPAPER_TARGET"
	xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorHDMI-1/workspace0/last-image --create -t string -s "$WALLPAPER_TARGET" 2>/dev/null || xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorHDMI-1/workspace0/last-image -s "$WALLPAPER_TARGET"
	xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/image-style --create -t int -s 5 2>/dev/null || xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/image-style -s 5
	killall xfdesktop 2>/dev/null || true
	nohup xfdesktop >/dev/null 2>&1 &
fi

if [ "$DRY_RUN" = false ]; then
	echo -e "\e[32m[OTOMATIS] Menerapkan tema WhiteSur-Dark & kompositor transparan...\e[0m"
	xfconf-query -c xsettings -p /Net/ThemeName --create -t string -s "WhiteSur-Dark" || xfconf-query -c xsettings -p /Net/ThemeName -s "WhiteSur-Dark"
	xfconf-query -c xfwm4 -p /general/theme --create -t string -s "WhiteSur-Dark" || xfconf-query -c xfwm4 -p /general/theme -s "WhiteSur-Dark"
	xfconf-query -c xfwm4 -p /general/button_layout --create -t string -s "CHM" || xfconf-query -c xfwm4 -p /general/button_layout -s "CHM"
	xfconf-query -c xfwm4 -p /general/use_compositing --create -t bool -s true || xfconf-query -c xfwm4 -p /general/use_compositing -s true
	xfconf-query -c xfwm4 -p /general/box_size --create -t int -s 4 || true
	xfconf-query -c xfce4-panel -p /panels/panel-1/background-alpha --create -t int -s 0 || xfconf-query -c xfce4-panel -p /panels/panel-1/background-alpha -s 0 2>/dev/null || true
	xfconf-query -c xfce4-panel -p /panels/panel-1/background-style --create -t int -s 0 || xfconf-query -c xfce4-panel -p /panels/panel-1/background-style -s 0 2>/dev/null || true
fi

if [ "$DEBUG_MODE" = false ]; then
	run_cmd "rm -rf '$BASE_DIR/ventura-xfce'"
fi

if [ "$DRY_RUN" = false ]; then
	echo -e "\e[32m[OTOMATIS] Memuat ulang modul panel dan desktop dari file disk...\e[0m"
	/usr/libexec/xfconfd & 2>/dev/null || /usr/lib/xfce4/xfconf/xfconfd & 2>/dev/null || xfconfd &
	sleep 0.2
	(xfce4-panel >/dev/null 2>&1 &)
	(xfdesktop >/dev/null 2>&1 &)
fi

trap - ERR
echo "=================================================="
if [ "$DRY_RUN" = true ]; then
	echo " Simulasi Selesai Tanpa Error!"
else
	echo " Setup Selesai! Silakan LOGOUT lalu LOGIN kembali untuk tampilan yang optimal."
fi
echo "=================================================="
