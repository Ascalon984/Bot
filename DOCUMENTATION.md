# BotWA — Dokumentasi

Dokumentasi ini menjelaskan cara menjalankan, mengonfigurasi, dan mengelola bot WhatsApp sederhana yang menggunakan library Baileys (fork `@whiskeysockets/baileys`).

## Ringkasan
Bot ini dirancang sebagai auto-reply pribadi:
- Hanya membalas chat pribadi (bukan grup).
- Menyediakan mode: `online`, `busy`, `offline`.
- Whitelist / blacklist untuk mengontrol siapa yang dibalas.
- Admin commands (via chat) untuk mengubah konfigurasi saat runtime.
- Fitur anti-spam: per-user cooldown dan opsi "reply sekali per sender" dengan penyimpanan persisten.
- Presence suppression: opsi agar bot menahan balasan bila owner baru aktif.


## Struktur file penting
- `index.js` — kode utama bot.
- `package.json` — dependensi dan script.
- `bot_config.json` — konfigurasi runtime (mode, ownerName, whitelist, blacklist, adminNumbers, dsb.).
- `auth_info/` — folder session (dibuat oleh Baileys / useMultiFileAuthState).
- `replied.json` — (jika digunakan) daftar nomor yang sudah dibalas sekali.
- `DOCUMENTATION.md` — file dokumentasi ini.


## Persyaratan
- Node.js (disarankan LTS, mis. v18+ atau v20+).
- Git (untuk instalasi/dependency jika diperlukan).
- Koneksi internet untuk npm install dan komunikasi WhatsApp.


## Instalasi (Windows PowerShell)
1. Buka PowerShell di folder proyek `C:\Users\User\Downloads\BotWA`.
2. Install dependensi:

```powershell
npm install
```

> Jika `npm install` gagal karena dependency yang menarik repo git via SSH, pastikan Git dapat mengakses GitHub atau gunakan fork yang tersedia di npm. Kode ini sudah diatur menggunakan `@whiskeysockets/baileys` sehingga seharusnya lewat registry.

3. Jalankan bot:

```powershell
npm start
```

Saat pertama kali dijalankan, skrip akan menampilkan QR di terminal (ASCII). Scan QR dari WhatsApp (Settings → Linked Devices → Link a device).

Push helper script
-------------------
Ada skrip bantu `push_to_github.ps1` yang dibuat untuk men-commit dan mendorong (push) semua file ke remote GitHub Anda (`https://github.com/Ascalon984/StaticBot.git`). Jalankan dari folder proyek di PowerShell:

```powershell
.\push_to_github.ps1
```

Skrip ini akan menanyakan konfirmasi sebelum mengganti remote `origin`. Ketik `y` atau `Y` untuk mengonfirmasi. Skrip tidak akan menjalankan `git push` sampai branch dan remote dikonfigurasi.


## Konfigurasi `bot_config.json`
Contoh struktur (file dibuat otomatis kalau belum ada):

```json
{
  "mode": "online",
  "ownerName": "Aditya",
  "whitelist": [],
  "blacklist": [],
  "adminNumbers": ["6283848600103"],
  "autoReply": true,
  "suppressWhenOwnerActive": false,
  "suppressTimeoutSeconds": 120,
  "replyCooldownSeconds": 3600
}
```

Penjelasan singkat:
- `mode`: `online` | `busy` | `offline`. Mengubah teks balasan otomatis.
- `ownerName`: nama yang tampil di balasan.
- `whitelist`: bila tidak kosong, hanya nomor di sini yang akan dibalas.
- `blacklist`: nomor yang akan diabaikan.
- `adminNumbers`: nomor admin (format internasional tanpa `+`, mis. `62812...`). Hanya admin bisa menjalankan perintah `!`.
- `autoReply`: true/false untuk menyalakan/menonaktifkan balasan otomatis.
- `suppressWhenOwnerActive`: jika true, bot menahan balasan bila owner baru aktif dalam `suppressTimeoutSeconds`.
- `suppressTimeoutSeconds`: durasi (detik) suppression setelah owner aktif.
- `replyCooldownSeconds`: durasi cooldown per pengirim (detik). Default proyek ini diset ke 3600 (1 jam).


## Perintah Admin (kirim pesan dari nomor yang terdaftar di `adminNumbers`)
Semua perintah harus diawali `!`.
- `!status online|offline|busy` — ubah mode.
- `!whitelist add|remove <nomor>` — tambah/hapus nomor whitelist.
- `!blacklist add|remove <nomor>` — tambah/hapus nomor blacklist.
- `!admin add|remove <nomor>` — tambahkan/hapus admin.
- `!suppress on|off` — aktif/nonaktifkan suppression based on owner presence.
- `!suppress timeout <seconds>` — atur timeout suppression.
- `!autoreply on|off` — aktif/nonaktifkan auto-reply global.
- `!cooldown <seconds>` — atur `replyCooldownSeconds`.
- `!replied show` — lihat jumlah nomor yang sudah mendapat first-reply.
- `!replied reset <nomor>` — reset status replied untuk nomor tertentu.
- `!replied reset all` — reset semua (membolehkan bot membalas lagi sekali ke semua nomor).
- `!show` — tampilkan konfigurasi saat ini.

Catatan: perintah dituliskan secara sederhana; gunakan nomor dalam format yang sama seperti yang disimpan (`628...`).


## Behavior anti-spam
- Bot memiliki mekanisme "reply once per sender" (persisted) — saat bot sudah membalas pertama kali ke nomor, ia tidak akan membalas lagi kecuali admin mereset status melalui `!replied reset`.
- Selain itu ada `replyCooldownSeconds` yang mengontrol seberapa sering bot boleh membalas ulang (jika Anda memilih untuk menggunakan timestamp-based reply map). Defaultnya saat ini diatur ke 3600 detik (1 jam).
- `suppressWhenOwnerActive` membantu mencegah bot membalas ketika owner baru saja aktif.


## Menjalankan di server (singkat)
- Pilih VM/host yang selalu online (mis. Oracle Cloud Free Tier, DigitalOcean droplet berbayar, atau VPS lain).
- Setelah transfer source ke server (git clone / scp), jalankan `npm install` lalu `npm start`.
- Untuk menjalankan sebagai service: gunakan `pm2` atau `systemd` (contoh di README utama).
- Pastikan session folder `auth_info` dan `replied.json` berada di storage persisten.


## Backup & Keamanan
- Jangan commit `auth_info` dan `replied.json` ke repo publik. `.gitignore` sudah disediakan.
- Backup `auth_info` agar Anda tidak perlu scan QR lagi jika VM ter-reset.
- Batasi akses SSH pada server; gunakan firewall.
- Ingat kebijakan WhatsApp: automasi berlebihan atau mengirim spam bisa menyebabkan pembatasan/ban.


## Troubleshooting
- `Error: Cannot find module '@adiwajshing/baileys'` — pastikan `npm install` berjalan dan dependensi yang memerlukan git cloning dapat diakses. Proyek ini menggunakan `@whiskeysockets/baileys` (registry) untuk menghindari clone SSH.
- Jika QR tidak tampil saat menjalankan di headless VM, jalankan melalui `ssh` dari komputer yang bisa menampilkan ASCII QR, atau gunakan `tmux`/`screen`.
- Jika bot tidak merespon, cek log terminal atau jalankan `node index.js` untuk melihat error stack.


## Opsional / Pengembangan lebih lanjut
- Tambahkan template balasan yang dapat dikonfigurasi di `bot_config.json`.
- Ganti penyimpanan `replied.json` ke SQLite atau Redis jika skalabilitas dibutuhkan.
- Tambahkan validasi nomor saat admin menambah whitelist/blacklist.
- Implementasikan webhook / antarmuka web untuk melihat logs dan mengubah konfigurasi tanpa edit file.


## Kontak & Lisensi
- Proyek ini disiapkan sebagai contoh. Gunakan dengan tanggung jawab sendiri. Jangan gunakan untuk spam.
- License: MIT (sesuaikan jika Anda ingin menambah klausul). 

---
Dokumentasi ini dibuat otomatis oleh alat bantu; beri tahu saya kalau Anda ingin menambahkan bagian contoh `bot_config.json` yang lebih lengkap, sample workflow deploy di Oracle / DigitalOcean, atau file service systemd/pm2 otomatis.
