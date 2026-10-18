#!/bin/bash

# 1. Hentikan engine konfigurasi Xfce sementara waktu
echo "Menghentikan layanan Xfconf..."
xfce4-panel --quit
pkill xfconfd
pkill xfsettingsd

# 2. Lakukan Full Reset (Hapus konfigurasi bawaan/lama)
#echo "Membersihkan konfigurasi lama..."
#rm -rf ~/.config/xfce4 ~/.cache/xfce4 ~/.config/xfconf ~/.cache/sessions

# 3. Buat direktori target yang baru bersih
TARGET_DIR="$HOME/.config/xfce4/xfconf/xfce-perchannel-xml"
mkdir -p "$TARGET_DIR"

# 4. Tentukan folder sumber tempat file kustom Anda berada saat ini
# Ubah path ini jika folder "dotconfig" Anda berada di lokasi lain (misal: $HOME/dotconfig/...)
SOURCE_DIR="$(pwd)/src/config/xfce4/xfconf/xfce-perchannel-xml"

echo "Menyalin konfigurasi khusus (Display, Keyboard, Shortcuts)..."
if [ -d "$SOURCE_DIR" ]; then
    cp "$SOURCE_DIR/displays.xml" "$TARGET_DIR/" 2>/dev/null
    cp "$SOURCE_DIR/keyboards.xml" "$TARGET_DIR/" 2>/dev/null
    cp "$SOURCE_DIR/xfce4-keyboard-shortcuts.xml" "$TARGET_DIR/" 2>/dev/null
    echo "Konfigurasi khusus berhasil disalin!"
else
    echo "Error: Folder sumber $SOURCE_DIR tidak ditemukan."
    echo "Pastikan Anda menjalankan script ini dari lokasi yang benar atau perbaiki path SOURCE_DIR."
fi

echo "Proses selesai. Silakan lakukan Log Out dan Log In kembali untuk menerapkan perubahan secara sempurna."
pkill xfce4
