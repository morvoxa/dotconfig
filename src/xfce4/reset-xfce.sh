reset() {
	echo "=================================================="
	echo " Memulai Reset Total XFCE ke Kondisi Baru Install..."
	echo "=================================================="

	# 0. AMAN: Matikan daemon pengunci file XML saja (Jangan xfce4-session dulu!)
	echo -e "\e[31m[OTOMATIS] Melepaskan penguncian database xfconfd...\e[0m"
	killall -9 xfce4-panel xfdesktop xfconfd 2>/dev/null || true
	pkill -9 -x xfce4-panel 2>/dev/null || true
	pkill -9 -x xfdesktop 2>/dev/null || true
	pkill -9 -x xfconfd 2>/dev/null || true
	sleep 0.3

	# 1. Hapus folder konfigurasi utama XFCE
	echo -e "\e[32m[1/6] Menghapus folder konfigurasi XFCE (~/.config/xfce4)...\e[0m"
	rm -rf ~/.config/xfce4

	# 2. Hapus cache sesi dan pengaturan xfconf murni dari disk
	echo -e "\e[32m[2/6] Membersihkan database xfconf per-channel...\e[0m"
	rm -rf ~/.config/xfce4/xfconf/xfce-perchannel-xml/* 2>/dev/null || true

	# 3. Hapus database dconf/gsettings tingkat rendah (Penyebab utama membal)
	echo -e "\e[32m[3/6] Menghancurkan cache dconf / gsettings tersembunyi...\e[0m"
	rm -rf ~/.config/dconf
	rm -rf ~/.cache/dconf

	# 4. Bersihkan total snapshot sessions & folder engine runtime DBus
	echo -e "\e[32m[4/6] Menghapus fail-safe snapshot session manager...\e[0m"
	rm -rf ~/.cache/sessions/*
	rm -rf ~/.cache/xfce4*
	rm -rf ~/.cache/Thunar

	# 5. Hapus konfigurasi Plank Dock, launcher kustom, & autostart
	echo -e "\e[32m[5/6] Menghapus konfigurasi Plank Dock & launcher...\e[0m"
	rm -rf ~/.config/plank
	rm -rf ~/.launchers
	rm -f ~/.config/autostart/plank.desktop
	rm -f ~/.config/autostart/feh-wallpaper.desktop 2>/dev/null || true

	# 6. Hapus wallpaper kustom
	echo -e "\e[32m[6/6] Membersihkan folder wallpaper kustom...\e[0m"
	rm -rf ~/.wallpapers

	echo "=================================================="
	echo " Reset Selesai! Memaksa pemutusan sesi X-Server..."
	echo " Sesi didepak instan agar sistem memuat ulang profil murni."
	echo "=================================================="
	sleep 0.5

	# POTONG JALUR AUTOMATIC SAVE (DILAKUKAN DI AKHIR):
	# Setelah semua file bersih, barulah kita bunuh session manager secara brutal
	# Ini mendepak Anda langsung ke display manager (layar login) Void Linux tanpa sempat auto-save.
	killall -9 xfce4-session 2>/dev/null || true
	pkill -9 -x xfce4-session 2>/dev/null || true
	pkill -9 -u "$USER" || pkill -9 Xorg || pkill -9 xinit
}
reset
reset
reset
reset
reset
reset
