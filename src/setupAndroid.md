# Panduan Setup Development Environment Linux

Dokumentasi ini memuat langkah-langkah instalasi OpenJDK secara manual dan konfigurasi Android CLI pada sistem operasi Linux.

---

## 1. Setup Java Environment (OpenJDK)

Ikuti langkah-langkah berikut untuk mengunduh dan mengonfigurasi OpenJDK secara manual tanpa manajer paket (package manager).

### Langkah 1: Unduh OpenJDK
Buka terminal dan jalankan perintah `wget` untuk mengunduh arsip OpenJDK versi 27:
```bash
wget https://download.java.net/java/GA/jdk27.0.1.0.3/b14170c9b2de463d9b89442c6db3e384/1/GPL/openjdk-27.0.1.0.3_linux-x64_bin.tar.gz
```

### Langkah 2: Ekstrak Arsip OpenJDK
Buat direktori khusus (misalnya di folder `$HOME/java`) dan ekstrak file yang telah diunduh:
```bash
mkdir -p ~/java
tar -zxvf openjdk-27.0.1.0.3_linux-x64_bin.tar.gz -C ~/java/
```

### Langkah 3: Konfigurasi Environment Variables
Tambahkan variabel lingkungan (environment variables) ke dalam profil shell Anda (misalnya `~/.bashrc` atau `~/.zshrc`):

1. Buka file konfigurasi shell:
   ```bash
   nano ~/.bashrc
   ```
2. Tambahkan baris konfigurasi berikut di bagian paling bawah file:
   ```bash
   # Java Environment Setup
   export JAVA_HOME=\$HOME/java/jdk-27.0.1.0.3
   export JAVA_PATH=\$JAVA_HOME/bin
   export PATH=\(JAVA_PATH:\)PATH
   ```
3. Simpan file (`Ctrl+O`, `Enter`) dan keluar dari editor (`Ctrl+X`).

### Langkah 4: Terapkan dan Verifikasi Perubahan
Muat ulang konfigurasi shell agar perubahan langsung aktif:
```bash
source ~/.bashrc
```
Verifikasi instalasi Java dengan memeriksa versinya:
```bash
java -version
```

---

## 2. Setup Android CLI

Gunakan skrip resmi untuk memasang Android Command Line Interface (CLI) dan menginisialisasi proyek baru.

### Langkah 1: Install Android CLI
Jalankan perintah berikut untuk mengunduh dan mengeksekusi skrip instalasi otomatis:
```bash
curl -fsSL https://dl.google.com/android/cli/latest/linux_x86_64/install.sh | bash
```
*Catatan: Skrip ini secara otomatis akan mendeteksi arsitektur sistem Anda, mengunduh file biner ke direktori `~/.local/bin`, dan mencoba mendaftarkannya ke dalam `$PATH` shell aktif Anda.*

### Langkah 2: Inisialisasi Proyek Baru
Setelah terminal dimuat ulang atau di-`source`, buat sebuah proyek Android baru menggunakan perintah CLI berikut:
```bash
android create \
  --application-id="com.appBasic.basic" \
  --output=basic-app \
  --name="App Basic"
```

---

## Verifikasi Akhir Environment
Untuk memastikan seluruh ekosistem development telah siap digunakan, pastikan perintah-perintah berikut merespons dengan benar di terminal baru Anda:
* `java -version` (Menampilkan info OpenJDK 27)
* `android --version` (Menampilkan info Android CLI terpasang)
