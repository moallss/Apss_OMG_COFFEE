# DESIGN.md — OMG COFFEE

Versi: v3 (final, sinkron mockup referensi: Login & Beranda Owner)
Tagline: "Coffee Keliling" · Struktur navigasi & keputusan produk tetap di DECISIONS_LOG.

---

## 1. BRAND IDENTITY

- Nama usaha: **OMG COFFEE** (font brand: BBH Hegarty, warna #3A6F43)
- Karakter: energik, modern, bersih — dominan putih dengan aksen pink kuat
- Hijau = identitas brand + aksen positif (ikon tren, link sekunder, status sukses)

## 2. COLOR TOKENS

| Token         | HEX                       | Peran (sesuai mockup)                                               |
| ------------- | ------------------------- | ------------------------------------------------------------------- |
| `primary`     | #EF2B7C                   | Header/halaman solid, aksen utama, ikon                             |
| `button`      | #FF3E9B                   | Fill button, quick-action bar, bottom navbar                        |
| `border`      | #D6336C                   | Border card, input, row (gaya outlined)                             |
| `cream`       | #FFF8F0                   | Surface card putih, teks/ikon di atas pink                          |
| `app-white`   | #FAF9F6                   | Background halaman (putih apps)                                     |
| `brand-green` | #3A6F43                   | Nama usaha, teks pendukung positif ("Belum punya akun?"), ikon tren |
| `ink`         | #1A1A1A                   | Teks utama                                                          |
| `muted`       | #8A8F98                   | Subtitle, placeholder                                               |
| `tint-pink`   | #FFE1EE                   | Empty state, highlight lembut                                       |
| `success`     | teks #3A6F43 / bg #E3EEE5 | Chip "Sudah Check-In", "+12,5% vs kemarin"                          |
| `warning`     | teks #B45309 / bg #FBEED7 | Chip "Hampir Habis", "Belum Check-In"                               |
| `danger`      | teks #DC2626 / bg #FDE3E7 | Chip "Habis", error                                                 |

CATATAN: tanpa gradient (header solid), tanpa shadow card (ganti gaya outlined).

## 3. TYPOGRAPHY

| Peran             | Font        | Weight          | Size             | Contoh di mockup                         |
| ----------------- | ----------- | --------------- | ---------------- | ---------------------------------------- |
| Nama usaha/brand  | BBH Hegarty | ter-tebal       | ≥20sp            | "OMG COFFEE" (splash/struk)              |
| Judul halaman     | Outfit      | Bold/ExtraBold  | 22–28            | "Selamat Datang", "Masuk ke Akun"        |
| Angka besar       | Outfit      | ExtraBold       | 26–32            | "Rp 1.250.000"                           |
| Judul section     | Outfit      | Bold            | 16–18 title-case | "Stok Kritis", "Status Karyawan"         |
| Tombol            | Outfit      | Bold            | 14–16            | "Masuk", "Daftar"                        |
| Body/deskripsi    | Inter       | Regular         | 13–14            | deskripsi login, sub row                 |
| Label kecil       | Inter       | Medium          | 12–13 title-case | "Omzet Hari ini", "Pengeluaran Hari Ini" |
| Nav & quick label | Inter       | Medium          | 10 UPPERCASE     | "BERANDA", "+ MENU"                      |
| Angka data        | Inter       | SemiBold + tnum | 13–16            | "Rp 270.000" di row                      |

Aturan: min 12sp untuk teks baca · nominal tabular · brand font 1x per layar.

## 4. SPACING / RADIUS / SHADOW

- Grid 4dp · padding layar 20dp · gap section 24dp · gap card/row 12dp
- Radius: sheet atas 24–32dp · card/row 16dp · input 12dp · button 14dp · chip pill · lingkaran ikon full
- Shadow: TIDAK ADA pada card (outlined style). Shadow lembut hanya untuk quick-bar & bottom-nav bila perlu depth.

## 5. ICONOGRAPHY

- Duotone/line, stroke 1.8–2dp
- Di atas pink: ikon #FFF8F0 (nav inactive #FFF8F0 70%)
- Di lingkaran putih (quick bar): ikon #EF2B7C
- Di surface terang: ikon #EF2B7C atau #3A6F43 (khusus indikator positif)

## 6. COMPONENTS (persis mockup)

| Komponen                   | Spek                                                                                                                                       |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Header                     | Solid #EF2B7C; teks & ikon #FFF8F0; avatar foto + border putih; bell + badge                                                               |
| Card statistik (di header) | Bg #FFF8F0 radius 16, tanpa border, divider 1dp #F0E4EA                                                                                    |
| Card/row outlined          | Bg #FFF8F0, border 1.5dp #D6336C, radius 16                                                                                                |
| Input                      | Bg #FAF9F6, border 1.5dp #D6336C, radius 12, ikon leading #EF2B7C, placeholder #8A8F98, eye toggle pink                                    |
| Button primary             | Bg #FF3E9B, teks #FFF8F0 Outfit Bold, radius 14, pressed #D6336C, disabled opacity 40%                                                     |
| Link sekunder              | Teks pendukung #3A6F43 + kata aksi #EF2B7C Bold ("Belum punya akun? Daftar")                                                               |
| Chip status                | Tint bg + teks berwarna (§2), 11–12sp Medium                                                                                               |
| Quick-action bar           | Bg #FF3E9B radius 20; lingkaran putih 48–56dp + ikon #EF2B7C; label #FFF8F0 10sp UPPERCASE                                                 |
| Bottom nav                 | Bg #FF3E9B radius atas 24; ACTIVE = lingkaran #FFF8F0 + ikon #EF2B7C + label bold; inactive = ikon/label #FFF8F0 70%; label UPPERCASE 10sp |
| Avatar row                 | Foto circle 40–44dp                                                                                                                        |

## 7. LAYOUT PATTERNS

- LOGIN: blok pink atas ±40% (judul Outfit + deskripsi Inter) → sheet krem radius atas 28 (judul form, input, link lupa password, button, link daftar).
- BERANDA: header pink + card statistik putih di dalamnya → quick bar overlap → sheet krem (section title Outfit title-case → horizontal snap card outlined dengan card ke-3 peek → row outlined).
- Section title: Outfit Bold title-case ink, tanpa link wajib; "Lihat Semua" opsional pink 12sp.

## 8. STATES

- Empty: ikon duotone #EF2B7C di lingkaran #FFE1EE + teks Inter muted
- Error input: border tetap #D6336C + pesan Inter 12 #DC2626
- Offline banner: bg #FBEED7 teks #B45309

## 9. COPY STANDARDS

- Bahasa Indonesia basis; istilah Inggris tetap: POS, Draft, Closing, Check-In/Out, Adjustment, QRIS, Cash, Audit, Read-Only
- Sapaan/deskripsi formal tanpa koma · placeholder pakai "Masukkan …" · nav copy: BERANDA · MASTER DATA · LAPORAN · PROFIL (uppercase render)

## 10. DO / DON'T

- DO: putih dominan · pink untuk aksi/navigasi · border pink tebal di card/input · hijau untuk brand & positif
- DON'T: gradient header · shadow card · palet kopi lama · biru/ungu · teks < 12sp · section title uppercase Inter

## 11. MOTION

- Easing cubic-bezier(0.22,1,0.36,1) · 200–300ms · splash ≤ 2,4s + skip

## 12. TOKEN NAMING (Flutter/GetX theme)

AppColors: primary, button, border, cream, appWhite, brandGreen, ink, muted, tintPink,
success/successTint, warning/warningTint, danger/dangerTint.
