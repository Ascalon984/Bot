# BotWA Autoreply (Baileys)

Skrip Node.js sederhana yang menggunakan Baileys untuk membalas pesan di chat pribadi WhatsApp secara otomatis.

PENTING: Gunakan hanya untuk akun pribadi dan non-spam. WhatsApp bisa membatasi/ban jika digunakan untuk penyalahgunaan.

Fitur:
- Autentikasi menggunakan single-file (QR scan sekali, tersimpan di `auth_info.json`).
- Hanya membalas chat pribadi (bukan grup).
- Contoh logika balasan sederhana; bisa dikembangkan lebih lanjut.

## Persyaratan
- Node.js (v16+ direkomendasikan)
- Windows PowerShell atau terminal lain

## Instalasi
1. Buka PowerShell di folder proyek (contoh: `c:\Users\User\Downloads\BotWA`).
2. Instal dependensi:

```powershell
npm install
```

(Package.json sudah mencantumkan dependensi: `@adiwajshing/baileys`, `qrcode-terminal`, `pino`.)

## Menjalankan
Jalankan perintah:

```powershell
npm start
```

- Saat pertama kali dijalankan, skrip akan menampilkan QR di terminal. Scan dengan WhatsApp di ponsel (Settings > Linked Devices > Link a device).
- Setelah tersambung, bot akan otomatis membalas pesan masuk di chat pribadi.

## File penting
- `index.js` — kode utama bot.
- `auth_info.json` — file yang menyimpan session (otomatis dibuat setelah scan QR).
- `.gitignore` — disertakan untuk mengabaikan `auth_info.json`.

## Kustomisasi
- Ubah logika balasan di `index.js` (handler `messages.upsert`).
- Tambahkan pengecualian, logging, atau integrasi dengan NLP sesuai kebutuhan.

## Catatan legal & keamanan
- Bot ini menggunakan WhatsApp Web API tidak resmi (Baileys). Penggunaan untuk automasi dapat melanggar kebijakan WhatsApp jika digunakan untuk spam, scraping, atau tindakan lain yang melanggar.
- Jangan gunakan untuk mengirim pesan massal. Gunakan hanya untuk akun pribadi atau testing.

Jika mau, saya bisa bantu menambahkan fitur: whitelist/blacklist nomor, auto-reply jadwal, atau integrasi penyimpanan lebih aman (database).