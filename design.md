---
title: "Helios Finance — Personal Finance Web Application"
version: "2.0.0"
status: "design-system"
sumber:
  kode: "index.html (v1 dashboard mock)"
  brief: "design.md (ringkasan visi sebelumnya)"
  produk: "prd.md v0.1"
stack:
  markup: "HTML5"
  styling: "Tailwind CSS v4"
  interaction: "Vanilla JavaScript + GSAP 3 (ScrollTrigger)"
  backend: "Supabase (PostgreSQL, Auth, RLS, PostgREST)"
  font: "Plus Jakarta Sans (Google Fonts)"
  framework: "None"
locale: "id-ID"
currency: "IDR"
timezone: "Asia/Jakarta (WIB, UTC+7)"
theme: "Dark-first, dual-theme (light tersedia, persisten)"
---

# DESIGN.md — Helios Finance

Sistem desain untuk aplikasi web manajemen keuangan pribadi yang dibangun di atas
Supabase + PostgreSQL dengan Row Level Security, sesuai PRD v0.1.

Dokumen ini adalah sumber kebenaran tunggal untuk seluruh keputusan visual dan
interaksi. `index.html` diperlakukan sebagai prototipe yang **harus dimigrasikan**
ke token di sini, bukan sebagai acuan yang dipertahankan apa adanya.

---

## 0. Prinsip Kerja Dokumen

1. Token di Bab 4–7 adalah satu-satunya sumber nilai. Nilai hex, rem, dan durasi
   yang ditulis langsung di dalam `className` atau `style` adalah pelanggaran.
2. Setiap komponen memiliki spesifikasi keadaan lengkap (default, hover, active,
   focus-visible, disabled, loading, selected, error, empty).
3. Setiap layar dipetakan ke ID kebutuhan PRD. Layar yang tidak punya ID PRD
   tidak boleh dibangun.
4. Aturan yang bertentangan dengan dokumen ini: dokumen ini yang menang.

---

## 1. Arah Desain

### 1.1 Arah dan Posisi

| Aspek | Keputusan |
| --- | --- |
| Genere | Aplikasi instrumen, bukan landing page pemasaran |
| Arah visual | Dark-first fintech, tenang, presisi, berorientasi data |
| Nada | Tenang, tanpa euforia, tanpa klaim hiperbolik |
| Kepadatan | Dense-kontrol: tinggi pada tabel dan angka, lega pada navigasi |
| Motion | Tiga jenjang, seluruhnya dapat dimatikan total |
| Ornamen | Nol. Tidak ada ilustrasi dekoratif, emoji, stempel, atau badge Navigation |
| Aksen | Satu warna aksen (magenta-soft) + tiga warna status semantik |

Prinsip Panduan: **angka harus benar sebelum numeriknya terlihat bagus.** Dengan
kata lain, presisi data, kelengkapan keadaan, dan keterbacaan lebih tinggi
prioritasnya daripada efek visual.

### 1.2 Yang Dihindari

- Gradien dekoratif yang tidak memuat data.
- Bayangan berlebihan; elevations hanya pada lapisan yang benar-benar terangkat.
- Kartu terlalu banyak pada satu layar. Tiga sampai lima komponen yang disengaja
  lebih baik daripada delapan komponen yang berdesakan.
- Setiap kartu memiliki satu tugas. Kartu yang perlu dua tugas dipecah.
- Label meta seperti "SECTION 01", "QUESTION 05", "ABOUT US", atau angka kartu
  yang tidak menjelaskan isi. Dilarang permanen.
- Copy marketing seperti "Decisions Powered by Data" pada produk yang tidak punya
  fitur tersebut.

### 1.3 Meta-label Ban

Label yang dilarang, dengan contoh yang terlarang: `Section 01`, `Step 2`, `Question 05`,
`Card 3`, `Overview v2`, `Module A`, `Insight #4`.

Pengganti yang benar-benar dipakai sistem:

| Kebutuhan | Salah | Benar |
| --- | --- | --- |
| Penomoran langkah wizard | Langkah 1 dari 3 | Pilih jenis transaksi |
| Penomoran modul nav | Modul 02 | Anggaran bulanan |
| Penomoran kartu metrik | Kartu 3 | Sisa anggaran makanan |
| Penomoran insight | Insight 04 | Tiga kategori mendekati batas |
| Judul bagian | Bagian anggaran | Anggaran bulan ini |

---

## 2. Matriks Keputusan Randomisasi

Untuk menghindari pola generatif yang berulang, token dan komponen utama
ditentukan lewat pemilihan acak deterministik dari basis prompt, bukan dari
pilihan pertama model.

### 2.1.seed

```
len(prompt_terkunci) = 137
137 % 97 = 40  ->  seed = 40
137 % 8  = 1   ->  shell axis
137 % 6  = 5   ->  tipografi
137 % 5  = 2   ->  komponen
137 % 4  = 1   ->  motion
```

### 2.2 Hasil Pemilihan

| Kerangka | Kandidat | terpilih |
| --- | --- | --- |
| Arsitektur shell | Cinematic Center / Artistic Asymmetry / Editorial Split | **Cinematic Center** |
| Tipografi | Satoshi / Cabinet Grotesk / Outfit / Geist | **Cabinet Grotesk** |
| Komponen | Inline Typography Image / Horizontal Accordion / Infinite Marquee / Feedback Carousel / Gapless Bento / Split Metric Rail | **Horizontal Accordion**, **Infinite Marquee**, **Feedback Carousel** |
| Motion | Pinned Split Scroll / Scrubbed Text Reveal / Image Scale & Fade / Card Stacking / Horizontal Scroll Pin | **Scrubbed Text Reveal**, **Card Stacking** |

### 2.3 Terjemahan kedomain keuangan

Pilihan di atas tidak dipakai apa adanya; dipetakan ke konteks produk:

| Pilihan acak | Wujud dalam aplikasi |
| --- | --- |
| Cinematic Center | Shell terpusat dengan satu sumbu optik tunggal dan lebar maksimum tetap. Konten tidak pernah menempel ke tepi viewport, tetapi juga tidak pernah melebar tanpa batas. Semua bagian mengikuti sumbu yang sama. |
| Cabinet Grotesk | Seluruh tipografi antarmuka. Angka tabular wajib. |
| Horizontal Accordion | Baris anggaran per kategori. Row tertutup menunjukkan realvs.limit; row terbuka melebar penuh dan memperlihatkan rincian transaksi kategori tersebut. |
| Infinite Marquee | Strip kategori berjalan pada modul Analitik. Menampilkan nama kategori beserta nominal dan persentase nonstop. |
| Feedback Carousel | Insight Carousel. Satu kartu menampilkan satu narasi anggaran yang dihitung dari status BUD-6. Bukan testimoniXG, bukan carouselLoaded. |
| Scrubbed Text Reveal | Paragraf narasi pada header modul Analitik. Kata-kata disorot sesuai posisi scroll. |
| Card Stacking | Lima transaksi terbaru pada Dashboard menumpuk dari bawah saat halaman digulir. |

### 2.4 Batas Randomisasi

Randomisasi hanya menentukan **pilihan**; kualitas tetap dijaga oleh gate di
Bab 16. Komponen yang terpilih wajib tetap memenuhi seluruh keadaan PRD.

---

## 3. Audit Kode `index.html` terhadap PRD

Tabel berikut adalah daftar temuan yang wajib dikerjakan. Kolom "Severity"
menentukan urutan pengerjaan.

| # | Temuan | Konflik dengan | Severity |
| --- | --- | --- | --- |
| A1 | Seluruh nominal memakai simbol `$` dan format US | PRD 5 (Konvensi Mata Uang), PROF-5 | Kritis |
| A2 | `<html lang="en">` dan seluruh copy berbahasa Inggris | PRD 3 (pengguna Indonesia) | Kritis |
| A3 | Kartu "Decisions Powered by Data" menjanjikan fitur AI | PRD 4.1 tidak memuat modul AI | Tinggi |
| A4 | `--font-sans: Inter` | Arahan tipografi (Inter dilarang) | Tinggi |
| A5 | Nilai hex ditulis langsung di dalam class (`bg-[#111012]`, `text-[#a9a3aa]`) | Bab 4 sistem token | Tinggi |
| A6 | Hanya satu tema (dark) | PROF-3, PROF-4 | Tinggi |
| A7 | Kolom kiri grid atas tidak pernah terisi penuh (`grid` tanpa `1fr` pada baris kedua) | Bab 8 | Tinggi |
| A8 | `min-h-[760px]` pada sidebar, angka ajaib yang tidak responsif | Bab 8 | Sedang |
| A9 | Data statis (`Nadia Rachel`, `nadia@helios.finance`, nominal yang ditulis langsung) | DASH-1..DASH-8 | Tinggi |
| A10 | Rentang grafik hanya `1D..1Y`, tidak ada bulan/kuartal | DASH-8 | Sedang |
| A11 | Grafik SVG statis tanpa sumber data dan tanpa alternatif tabel aksesibel | DASH-7 | Tinggi |
| A12 | Tidak ada keadaan loading, empty, maupun error di seluruh layar | Bab 14 | Tinggi |
| A13 | Navigasi `href="#"` tanpa `aria-current` | PROF-1, AUTH-6 | Sedang |
| A14 | Tidak ada entry point CRUD transaksi di header | TRX-1 | Tinggi |
| A15 | `Goals` ada di nav tetapi tidak ada konten | SAV-1..SAV-8 | Tinggi |
| A16 | Warna teks `#777278` berbanding `#111012` hanya 4.03:1 | AA untuk teks normal | Sedang |
| A17 | Radius `16 / 14 / 13 / 10 / 9 / 8` tidak berjenjang | Bab 7 | Sedang |
| A18 | Ikon inline diulang 12 kali tanpa abstraksi | Bab 9 | Sedang |
| A19 | Tombol overflow di header (`•••`) tanpa perilaku | Bab 13 | Rendah |
| A20 | Budget dan Analytics belum punya container di shell | BUD-1, DASH-7 | Tinggi |

---

## 4. Token Sistem

### 4.1 Pemuatan Font

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:ital,wght@0,400;0,500;0,600;0,700;0,800;1,400&display=swap">
```

Plus Jakarta Sans menggantikan Cabinet Grotesk atas permintaan eksplisit
pengguna (kesan lebih premium, digambar untuk kebutuhan Indonesia). Font
fallback berjenjang mencegah layout shift saat font gagal dimuat.

### 4.2 Blok `@theme` Tailwind CSS v4

```css
@theme {
  --font-sans: "Plus Jakarta Sans", ui-sans-serif, system-ui, -apple-system, "Segoe UI", sans-serif;
  --font-mono: ui-monospace, "SFMono-Regular", "Cascadia Mono", Menlo, monospace;

  --color-canvas: #0a090a;
  --color-canvas-veil: #0d0c0e;
  --color-shell: #171518;
  --color-surface: #111012;
  --color-surface-2: #151316;
  --color-surface-3: #19171a;
  --color-overlay: #252126;

  --color-ink: #f5f1f5;
  --color-ink-muted: #a9a3aa;
  --color-ink-subtle: #8b858e;
  --color-ink-faint: #777278;

  --color-brand: #d69acf;
  --color-brand-soft: #f0c7ea;
  --color-brand-muted: #9b789c;
  --color-brand-ink: #1b171b;
  --color-brand-wash: rgba(214, 154, 207, 0.15);

  --color-positive: #5edb9b;
  --color-caution: #e8b04b;
  --color-negative: #e8635a;

  --color-line: rgba(245, 241, 245, 0.10);
  --color-line-soft: rgba(245, 241, 245, 0.08);
  --color-line-strong: rgba(245, 241, 245, 0.20);
  --color-line-control: rgba(245, 241, 245, 0.38);

  --radius-field: 10px;
  --radius-tile: 13px;
  --radius-card: 14px;
  --radius-panel: 16px;
  --radius-dialog: 20px;
  --radius-pill: 999px;

  --shadow-float: 0 8px 24px rgba(0, 0, 0, 0.35);
  --shadow-panel: 0 20px 60px rgba(0, 0, 0, 0.45);
  --shadow-shell: 0 30px 100px rgba(0, 0, 0, 0.45);
  --shadow-modal: 0 40px 120px rgba(0, 0, 0, 0.60);
  --shadow-brand: 0 0 0 1px rgba(214, 154, 207, 0.06), 0 20px 70px rgba(214, 154, 207, 0.08);

  --text-display: 32px;
  --text-display--line-height: 1.15;
  --text-display--letter-spacing: -0.035em;
  --text-display--font-weight: 500;

  --text-section: 21px;
  --text-section--line-height: 1.25;
  --text-section--letter-spacing: -0.025em;
  --text-section--font-weight: 500;

  --text-card: 16px;
  --text-card--line-height: 1.35;
  --text-card--letter-spacing: -0.015em;
  --text-card--font-weight: 500;

  /* 22px - 31px, fluid terhadap lebar kartu, bukan lebar viewport.
     Lihat 6.3a. */
  --text-metric: clamp(1.375rem, 15.5cqi, 1.9375rem);
  --text-metric--line-height: 1.1;
  --text-metric--letter-spacing: -0.040em;
  --text-metric--font-weight: 500;

  --text-figure: 15px;
  --text-figure--line-height: 1.3;
  --text-figure--letter-spacing: -0.02em;
  --text-figure--font-weight: 500;

  --text-body: 13px;
  --text-body--line-height: 1.55;
  --text-body--letter-spacing: -0.005em;

  --text-label: 12px;
  --text-label--line-height: 1.4;

  --text-meta: 11px;
  --text-meta--line-height: 1.4;

  --text-micro: 10px;
  --text-micro--line-height: 1.35;

  --text-axis: 9px;
  --text-axis--line-height: 1.2;

  --ease-soft: cubic-bezier(0.22, 0.61, 0.36, 1);
  --ease-emphasized: cubic-bezier(0.16, 1, 0.30, 1);
  --ease-exit: cubic-bezier(0.40, 0, 1, 1);

  --animate-marquee: marquee 48s linear infinite;
  --animate-rise: rise 320ms cubic-bezier(0.16, 1, 0.30, 1) both;
}

@keyframes marquee {
  from { transform: translate3d(0, 0, 0); }
  to { transform: translate3d(-50%, 0, 0); }
}

@keyframes rise {
  from { opacity: 0; transform: translate3d(0, 10px, 0); }
  to { opacity: 1; transform: translate3d(0, 0, 0); }
}
```

### 4.3 Tema Terang

Tema gelap adalah default. Tema terang bukan pembalikan otomatis, melainkan
surcharge yang mempertahankan hierarki semantik yang sama.

```css
:root[data-theme="light"] {
  --color-canvas: #f4f2f5;
  --color-canvas-veil: #ffffff;
  --color-shell: #ffffff;
  --color-surface: #ffffff;
  --color-surface-2: #faf8fa;
  --color-surface-3: #f1eef2;
  --color-overlay: #ffffff;

  --color-ink: #17151a;
  --color-ink-muted: #5c5760;
  --color-ink-subtle: #6f6973;
  --color-ink-faint: #918b95;

  --color-brand: #a75fa0;
  --color-brand-soft: #8e4a88;
  --color-brand-muted: #c58dbd;
  --color-brand-ink: #ffffff;
  --color-brand-wash: rgba(167, 95, 160, 0.12);

  --color-positive: #14775a;
  --color-caution: #8a6410;
  --color-negative: #c0392b;

  --color-line: rgba(23, 21, 26, 0.10);
  --color-line-soft: rgba(23, 21, 26, 0.07);
  --color-line-strong: rgba(23, 21, 26, 0.20);
  --color-line-control: rgba(23, 21, 26, 0.42);

  --shadow-float: 0 6px 20px rgba(23, 21, 26, 0.08);
  --shadow-panel: 0 18px 48px rgba(23, 21, 26, 0.10);
  --shadow-shell: 0 24px 80px rgba(23, 21, 26, 0.12);
  --shadow-modal: 0 32px 96px rgba(23, 21, 26, 0.18);
  --shadow-brand: 0 0 0 1px rgba(167, 95, 160, 0.08), 0 18px 60px rgba(167, 95, 160, 0.12);
}
```

Aturan tema:

- Tidak ada kelas warna langsung di dalam komponen. Semua warna masuk lewat
  token semantik.
- Tombol pada tema terang memakai `bg-brand-ink text-surface`, bukan
  `text-white`, agar kontras tetap terukur.
- Grafik memakai `currentColor` dan token status, sehingga mengikuti tema
  otomatis.
- Pilihan tema disimpan ke `profiles.theme_preference` (PROF-3) dan diterapkan
  pada elemen `<html>` sebelum paint pertama agar tidak ada kedipan tema.

```html
<script>
  document.documentElement.dataset.theme = "dark";
</script>
```

---

## 5. Sistem Warna

### 5.1 Peran Warna

| Token | Pemakaian | Dilarang untuk |
| --- | --- | --- |
| `canvas` | Latar halaman di luar shell | Teks, border |
| `shell` | Permukaan shell aplikasi | Teks |
| `surface` | Permukaan semua kartu dan panel | Teks |
| `surface-2` | Permukaan nested di dalam kartu | Teks |
| `surface-3` | Hover pada baris daftar | Teks |
| `overlay` | Tooltip, popover, dropdown | Teks |
| `ink` | Judul, angka utama, nilai transaksi | Latar |
| `ink-muted` | Label sekunder, deskripsi, sumbu | Latar |
| `ink-subtle` | Meta, waktu, satuan | Latar |
| `ink-faint` | Garis grid, placeholder non-esensial | Teks yang wajib dibaca |
| `brand` | Pilihan aktif, sorotan, aksen grafik | Teks kecil di atas `surface` tanpa uji kontras |
| `brand-ink` | Teks di atas permukaan `brand` | Keperluan lain |
| `positive` | Pemasukan, anggaran sehat, delta positif | Non-moneter tanpa makna untung |
| `caution` | Anggaran mendekati batas, peringatan | Dekorasi |
| `negative` | Pengeluaran, anggaran melebihi batas, error | Dekorasi |

### 5.2 Tabel Kontras Terukur

Seluruh angka di bawah dihitung dengan rumus WCAG 2.1, bukan diperkirakan.

Tema gelap, terhadap `surface` (`#111012`):

| Kombinasi | Rasio | AA teks normal | AA teks besar | Pemakaian |
| --- | --- | --- | --- | --- |
| `ink` / `surface` | 16.97:1 | Lolos | Lolos | Judul, angka utama |
| `ink-muted` / `surface` | 7.69:1 | Lolos | Lolos | Label sekunder |
| `ink-subtle` / `surface` | 5.28:1 | Lolos | Lolos | Meta, waktu |
| `ink-faint` / `surface` | 4.03:1 | **Gagal** | Lolos | Hanya garis grid dan placeholder dekoratif |
| `brand` / `surface` | 8.48:1 | Lolos | Lolos | Aksen, sorotan |
| `brand-ink` / `brand` | 7.92:1 | Lolos | Lolos | Tombol utama |
| `positive` / `surface` | 10.92:1 | Lolos | Lolos | Delta positif |
| `caution` / `surface` | 9.71:1 | Lolos | Lolos | Status mendekati batas |
| `negative` / `surface` | 5.75:1 | Lolos | Lolos | Status melebihi batas |
| `brand-soft` / `canvas` | 13.31:1 | Lolos | Lolos | Tanda sorotan |

Tema terang, terhadap `surface` (`#ffffff`):

| Kombinasi | Rasio | AA teks normal | AA teks besar | Pemakaian |
| --- | --- | --- | --- | --- |
| `ink` / `surface` | 18.13:1 | Lolos | Lolos | Judul, angka utama |
| `ink-muted` / `surface` | 7.03:1 | Lolos | Lolos | Label sekunder |
| `ink-subtle` / `surface` | 5.32:1 | Lolos | Lolos | Meta, waktu |
| `brand` / `surface` | 4.39:1 | **Gagal** | Lolos | Isian dan garis grafik |
| `brand-soft` / `surface` | 6.03:1 | Lolos | Lolos | Tautan, teks aksen |
| `positive` / `surface` | 5.50:1 | Lolos | Lolos | Delta positif |
| `caution` / `surface` | 5.37:1 | Lolos | Lolos | Status mendekati batas |
| `negative` / `surface` | 5.44:1 | Lolos | Lolos | Status melebihi batas |

Konsekuensi tema terang: `brand` tidak boleh dipakai sebagai warna teks. Teks
aksen pada tema terang memakai `brand-soft`, sedangkan `brand` hanya untuk
isian, garis, dan grafik.

Kontras non-teks (WCAG 1.4.11) memerlukan 3:1 terhadap latar. Hairline `line`
pada tema gelap menghasilkan 1.26:1 dan karena itu **tidak boleh** dipakai
sebagai batas kontrol interaktif. Batas form dan checkbox memakai
`line-control` (putih 38% di atas `surface`, 3.33:1).

### 5.3 Aturan Penggunaan Aksen

- Aksen hanya untuk tiga hal: keadaan terpilih, keadaan fokus, dan penekanan
  angka positif.
- Maksimal satu elemen brand pada satu tatapan layar, kecuali daftar filter yang
  memang berdiri sendiri.
- Warna tidak pernah menjadi satu-satunya pembawa makna. Setiap status anggaran
  selalu disertai label teks dan bentuk ikon yang berbeda.
- Tidak ada gradien brand pada teks. Tidak ada `background-clip: text`.
- Glow `shadow-brand` hanya pada satu elemen fokus flagship per layar.

---

## 6. Tipografi

### 6.1 Stack

| Peran | Font | Fallback |
| --- | --- | --- |
| Antarmuka dan display | Plus Jakarta Sans 400/500/600/700/800 | `ui-sans-serif, system-ui, -apple-system, "Segoe UI", sans-serif` |
| Angka untuk mode spreadsheet | `--font-mono` | `ui-monospace, SFMono-Regular, Cascadia Mono, Menlo, monospace` |

### 6.2 Skala

| Token | Ukuran | Line height | Tracking | Weight | Pemakaian |
| --- | --- | --- | --- | --- | --- |
| `text-display` | 32px | 1.15 | -0.035em | 500 | Judul halaman, nominal utama |
| `text-section` | 21px | 1.25 | -0.025em | 500 | Judul bagian, nama goal |
| `text-card` | 16px | 1.35 | -0.015em | 500 | Judul kartu |
| `text-metric` | 22-31px fluid | 1.10 | -0.040em | 500 | Nominal besar pada kartu metrik, lihat 6.3a |
| `text-figure` | 15px | 1.30 | -0.020em | 500 | Nominal pada nested tile |
| `text-body` | 13px | 1.55 | -0.005em | 400 | Teks isi, deskripsi |
| `text-label` | 12px | 1.40 | 0 | 500 | Label form, tombol |
| `text-meta` | 11px | 1.40 | 0 | 400 | Meta, tanggal, sumber |
| `text-micro` | 10px | 1.35 | 0.01em | 500 | Badge, status pill |
| `text-axis` | 9px | 1.20 | 0.04em | 500 | Label sumbu, tick grafik |

Aturan keras:

- Tidak ada ukuran font di luar tabel ini. Kebutuhan baru berarti tabel ini
  diperbarui, bukan improvisasi.
- Tidak ada `line-clamp` pada judul. Judul memanjang, tidak dipotong.
- Tracking negatif hanya pada ukuran di atas 20px. Tracking positif hanya pada
  `text-axis`.
- Weight 700 hanya untuk penekanan dan judul modal. Tidak ada teks isi
  tebal.

### 6.3 Angka

```css
:root {
  font-variant-numeric: tabular-nums;
}

.figure {
  font-variant-numeric: tabular-nums slashed-zero;
  font-feature-settings: "tnum" 1, "zero" 1;
}

.figure-align {
  font-variant-numeric: tabular-nums;
  font-family: var(--font-mono);
  font-size: 0.94em;
  letter-spacing: -0.02em;
}
```

Tracking hanya datang dari type scale. `.figure` tidak boleh mengatur
`letter-spacing`, karena utility `text-*` berada di `@layer utilities` dan
selalu kalah dari selector class di luar layer. Kalau `.figure` menulis
`letter-spacing`, nilai `-0.040em` pada `text-metric` mati diam-diam.

### 6.3a Nominal besar pada kartu

Nominal kartu metrik harus muat di dalam kartu pada lebar empat kolom
(1280px), di mana content box kartu hanya 174px. Nominal `Rp48.320.500`
pada 31px memakai sekitar 180px, jadi tetap meluber.

```css
/* Jadikan kartu sebagai container agar nominal diskalakan relatif
   lebar kartu, bukan lebar viewport. Padding dan border kartu tetap. */
.metric-card {
  container-type: inline-size;
  min-width: 0;
}

.balance {
  min-width: 0;
  max-width: 100%;
  letter-spacing: -0.040em;
  white-space: nowrap;
  overflow-wrap: anywhere;
}
```

Aturan nominal besar:

- `--text-metric` fluid antara 22px dan 31px memakai satuan `cqi` relative
  terhadap `.metric-card`. Fluid terhadap lebar kartu, bukan `vw`, supaya
  perubahan padding shell atau lebar sidebar tidak membuat nominal meluber
  lagi.
- Angka 15.5cqi berasal dari pengukuran content box kartu, bukan tebakan:

  | Viewport | Kolom | Content box kartu | Ukuran font |
  | --- | --- | --- | --- |
  | 375px | 1 | 259px | 31px (ceiling) |
  | 768px | 2 | 292px | 31px (ceiling) |
  | 1280px | 4 | 174px | 27px |
  | 1366px | 4 | 196px | 30px |
  | 1440px+ | 4 | 204px | 31px (ceiling) |

  Kolom ter sempit adalah 1280px, bukan 1440px.
- Floor 22px tetap di atas 20px, jadi tracking negatif `-0.040em` tetap
  sah menurut aturan 6.2.
- Nominal tetap satu baris (`white-space: nowrap`). Memakai `nowrap` dengan
  token fluid membuat nominal lebih kecil secara proporsional, bukan
  terbelah dua baris.
- `overflow-wrap: anywhere` hanya jaring pengaman untuk nilai di luar rentang
  desain. Ia bukan solusi utama: kalau aktif, artinya ruang tidak cukup dan
  ukuran fluid gagal. Padding, ukuran kartu, dan `overflow: hidden` tidak
  boleh dipakai untuk menyelesaikan overflow nominal.
- Kartu tidak boleh ditambah lebar khusus agar accommodate nominal. Lebar
  kartu dan padding mengikuti layout yang berlaku.

Aturan angka:

- Setiap kolom nominal menggunakan `font-variant-numeric: tabular-nums` agar
  digit sejajar vertikal.
- Nominal negatif selalu memakai tanda minus U+2212, bukan tanda hubung, agar
  sejajar dengan digit positif.
- Persentase dan delta selalu dua digit desimal, dengan tanda eksplisit `+` atau
  `-`.
- Angka pada sumbu grafik memakai `text-axis` dan `ink-faint` karena hanya
  navigatif; nilai presisinya tetap tersedia di tooltip dan tabel data.

### 6.4 Aturan Copy

- Bahasa Indonesia baku, tanpa campuran bahasa pada satu label.
- Tidak ada huruf kapital di awal kalimat kecuali nama resmi atau singkatan.
- Tidak ada tanda seru pada microcopy sistem. Galat menyatakan fakta, bukan
  emosi.
- Angka memakai pemisah ribuan titik, desimal koma.
- Tidak ada emoji di seluruh antarmuka, termasuk di dalam dokumen ini.

---

## 7. Spasi, Radius, Border, Elevation

### 7.1 Spasi

Basis 4px. Hanya nilai berikut yang diizinkan.

| Token | Nilai | Pemakaian |
| --- | --- | --- |
| `space-1` | 4px | Jarak ikon ke label |
| `space-2` | 8px | Jarak label ke meta |
| `space-3` | 12px | Padding kartu padat, jarak kontrol |
| `space-4` | 16px | Padding kartu, jarak baris grup |
| `space-5` | 20px | Padding kartu standar |
| `space-6` | 24px | Padding kartu besar |
| `space-8` | 32px | Jarak antar bagian dalam satu tab |
| `space-10` | 40px | Padding shell bagian bawah |
| `space-12` | 48px | Jarak bagian utama |

Grid memakai gap `10px` (`gap-2.5`) sebagai default dan `12px` untuk grid yang
lebih longgar. Nilai lain hanya pada grid-dense.

### 7.2 Radius

| Token | Nilai | Pemakaian |
| --- | --- | --- |
| `radius-field` | 10px | Input, select, pemilih tanggal |
| `radius-tile` | 13px | Nested tile di dalam kartu |
| `radius-card` | 14px | Kartu dan panel |
| `radius-panel` | 16px | Shell aplikasi |
| `radius-dialog` | 20px | Modal dan drawer |
| `radius-pill` | 999px | Tombol, filter, status pill, avatar |

Aturan: nested surface selalu memiliki radius lebih kecil dari induknya. Kartu
`14px` memuat tile `13px` dan field `10px`. Tidak ada radius `8px` di sistem ini.

### 7.3 Border

| Token | Nilai | Pemakaian |
| --- | --- | --- |
| `line-soft` | putih 8% | Pembatas internal, pemisah baris |
| `line` | putih 10% | Border kartu |
| `line-strong` | putih 20% | Border tombol outline dan hover |
| `line-control` | putih 38% | Border input yang wajib terbaca |

Setiap border berada pada sisi tunggal. `border` pada empat sisi sekaligus hanya untuk shell dan panel.

### 7.4 Elevation

| Lapisan | Token | Nilai | Pemakaian |
| --- | --- | --- | --- |
| 0 | tanpa bayangan | none | Kartu, tabel, baris |
| 1 | `shadow-float` | 0 8px 24px rgba(0,0,0,.35) | Dropdown, popover, tooltip |
| 2 | `shadow-panel` | 0 20px 60px rgba(0,0,0,.45) | Drawer, panel mengambang |
| 3 | `shadow-shell` | 0 30px 100px rgba(0,0,0,.45) | Shell aplikasi pada kanvas |
| 4 | `shadow-modal` | 0 40px 120px rgba(0,0,0,.60) | Dialog |
| Aksen | `shadow-brand` | ring 6% + glow 8% | Satu elemen fokus per layar |

Elevasi nol adalah default dan boleh dipakai pada 90% permukaan. Naikkan
elevasi hanya ketika benar-benar ada overlay di atasnya.

---

## 8. Layout dan Anatomi Shell

### 8.1 Hierarki wilayah pada halaman aplikasi

```
kanvas
└── shell (max-w 1320, radius panel, p-3, shadow-shell, overflow hidden)
    ├── sidebar (w 248, radius card, glass, flex column)
    │   ├── brand (32px mark + wordmark 15px)
    │   ├── nav utama (5 item, pill row, h-44)
    │   ├── nav sekunder (2 item, mt-auto)
    │   └── user strip (avatar 36 + nama + email)
    └── content (min-w 0, px-4, py-5)
        ├── topbar (judul + subtitle | aksi primer + ikon + user)
        ├── toolbar (tab segmented | pencarian global | filter)
        ├── metrics grid (bento 3 kolom, dense)
        ├── panel utama (chart / tabel / daftar)
        └── pagination (kiri: jumlah data, kanan: kontrol halaman)
```

### 8.2 Rumus Lebar (Bukti Perhitungan)

Lebar shell tetap `1320px`.

```
lebar dalam shell  = 1320 - (2 x 12 padding shell) = 1296
lebar kolom konten = 1296 - 248 sidebar - 1 border = 1047
lebar isi konten   = 1047 - (2 x 16 padding konten) = 1015
```

Grid metrics memakai `grid-cols-[1fr_1.08fr_1fr]` dengan `gap-2.5` (10px).

```
total fr        = 1 + 1.08 + 1 = 3.08
lebar tersedia  = 1015 - (2 x 10) = 995
satuan fr       = 995 / 3.08 = 323.05
kolom 1         = 323.05
kolom 2         = 348.90
kolom 3         = 323.05
total            = 995.00  -> pas, tanpa sisa
```

Pada viewport 1280 dan 1024, grid runtuh menjadi 2 kolom lalu 1 kolom dengan
urutan baca yang sama: metrik utama, daftar kategori, ringkasan tile.

### 8.3 Bukti Nol Void pada Grid

Temuan A7: pada `index.html` kolom kiri memakai `grid` dengan dua baris `auto`,
sehingga tinggi kolom tidak sama dengan dua kolom sebelah dan muncul rongga
bawah. Perbaikan wajib:

```html
<div class="grid grid-rows-[auto_1fr] gap-2.5">
  <article>...</article>
  <article>...</article>
</div>
```

Baris pertama menempel ke atas sesuai sizing naturalnya, baris kedua menyerap
seluruh sisa tinggi. Tiga kolom di luarnya memakai `items-stretch` implisit dari grid,
sehingga tinggi ketiga kartu selalu sama. Baris kedua bento memakai
`xl:col-span-3` sehingga tidak pernah menyisakan kolom kosong.

### 8.4 Batas Anti-Void

- Setiap baris grid harus menjumlah tepat ke lebar tersedia. Tidak ada `col-span`
  yang jumlahnya kurang dari jumlah kolom.
- `grid-flow-dense` dipakai pada setiap grid yang jumlah selnya tidak
  seragam. Dengan dense, sel kecil mengisi rongga yang tertinggal.
- Grid yang jumlah kolomnya seragam tidak memakai dense karena tidak ada rongga
  untuk diisi.
- Dilarang menggunakan tinggi tetap pada kartu data. Tinggi mengikuti konten,
  kecuali kartu chart yang punya tinggi minimum eksplisit.

### 8.5 Breakpoint

| Nama | Lebar | Perubahan |
| --- | --- | --- |
| `sm` | 640px | Topbar menumpuk vertikal; grid 1 kolom |
| `md` | 768px | Toolbar kontrol terlihat penuh |
| `lg` | 1024px | Sidebar muncul, shell `min-h` dinamis |
| `xl` | 1280px | Bento 3 kolom aktif |
| `2xl` | 1536px | Shell tetap 1320, jarak tepi bertambah |

`min-h-[760px]` pada prototipe diganti:

```html
class="min-h-[calc(100dvh-4rem)]"
```

`100dvh`, bukan `100vh`, agar shell tidak meluber saat mobile browser menyusut.
`min-h-[calc(100vh-8rem)]` pada halaman diganti `min-h-[100dvh]`.

### 8.6 Mode Tablet dan Mobile

- Di bawah `lg`, sidebar menjadi navigasi bawah dengan lima item teratas dan
  satu tombol menu yang memunculkan nav sekunder sebagai sheet.
- Tabel desktop menjadi daftar kartu pada mobile. Kolom yang diprioritaskan pada
  mobile: nama atau deskripsi, nominal, tanggal. Kategori dan metode pembayaran
  menjadi baris meta.
- Filter aktif (diriliskan sebagai chip yang dapat dihapus) pindah ke atas daftar,
  bukan disembunyikan di balik menu.

---

## 9. Spesifikasi Komponen

Setiap komponen wajib memiliki keadaan lengkap yang tercantum.

### 9.1 Tombol

| Varian | Latar | Teks | Border | Padding | Font |
| --- | --- | --- | --- | --- | --- |
| `primary` | `brand` | `brand-ink` | none | 10px 20px | `text-label` 500 |
| `secondary` | `surface-2` | `ink` | `line` | 10px 20px | `text-label` 500 |
| `outline` | transparent | `ink-muted` | `line-strong` | 10px 20px | `text-label` 500 |
| `quiet` | transparent | `ink-muted` | none | 10px 16px | `text-label` 500 |
| `danger` | `negative` 12% | `negative` | `negative` 32% | 10px 20px | `text-label` 500 |
| `ghost-icon` | `canvas-veil` | `ink-muted` | `line` | 0, 44x44 | tanpa teks |

Keadaan:

| Keadaan | Perubahan |
| --- | --- |
| Awan | sesuai varian |
| Kursor mendekat | latar terang 6%, border ke `line-strong`, durasi 160ms |
| Ditekan | `translateY(0.5px)`, durasi 80ms |
| Fokus | ring 2px `brand`, offset 2px, tanpa perubahan warna |
| Nonaktif | opacity 0.45, `cursor: not-allowed`, tanpa efek kursor |
| Memproses | spinner 16px menggantikan label, lebar tombol dipertahankan, `aria-busy="true"` |

Tombol tidak pernah memakai `text-white` di atas `brand` pada tema terang.
Kombinasi tombol dengan rasio kontras di bawah 4.5:1 untuk teks 12px dianggap
bug, bukan preferensi.

```html
<button class="h-10 rounded-pill bg-brand px-5 text-label font-medium text-brand-ink transition-colors duration-150 hover:brightness-110 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-brand disabled:opacity-45">
  Catat transaksi
</button>
```

### 9.2 Kolom Input

Anatomi: label di atas, input, helper atau error di bawah. Jarak label ke input
4px, input ke helper 6px.

| Ukuran | Tinggi | Font | Padding horizontal |
| --- | --- | --- | --- |
| `md` | 40px | `text-body` | 12px |
| `lg` | 48px | `text-body` | 14px |
| `amount` | 48px | `text-metric` tabular | 14px |

| Keadaan | Border | Latar | Teks |
| --- | --- | --- | --- |
| default | `line-control` | `surface-2` | `ink` |
| hover | `line-control` + 12% `ink` | `surface-3` | `ink` |
| focus | `brand` 2px, ring offset 0 | `surface-2` | `ink` |
| filled | `line` | `surface-2` | `ink` |
| error | `negative` | `surface-2` | `ink` |
| disabled | `line-soft` | `surface` | `ink-faint` |

Field nominal wajib memakai `inputmode="numeric"` dengan awalan visual `Rp`
di dalam wrapper, bukan di dalam `value`. Nilai yang tersimpan tetap angka murni.

### 9.3 Segmented Control (Tab View)

Menggabungkan tiga mode tampilan dashboard: Ringkasan, Anggaran, Analitik.

```html
<div role="tablist" aria-label="Mode tampilan" class="flex items-center gap-1.5">
  <button role="tab" aria-selected="true" class="rounded-pill bg-ink px-5 py-2.5 text-label font-medium text-shell transition-colors duration-150 hover:brightness-90 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-brand">Ringkasan</button>
  <button role="tab" aria-selected="false" class="rounded-pill bg-surface px-5 py-2.5 text-label text-ink-muted transition-colors duration-150 hover:bg-surface-3 hover:text-ink focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-brand">Anggaran</button>
  <button role="tab" aria-selected="false" class="rounded-pill bg-surface px-5 py-2.5 text-label text-ink-muted transition-colors duration-150 hover:bg-surface-3 hover:text-ink focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-brand">Analitik</button>
</div>
```

Perbedaan dari prototipe: tab aktif memakai `bg-ink text-shell` pada tema
gelap, bukan `bg-brand`. Aksen disimpan untuk keadaan yang benar-benar
membedakan data, bukan untuk pilihan navigasi biasa.

### 9.4 Filter Chip Periode

`1D / 1W / 1M / 3M / 6M / 1Y` ditambah `Kustom`, dipakai pada modul analitik
dan grafik. Chip aktif memakai `bg-brand text-brand-ink`. Chip nonaktif memakai
`border-line-strong text-ink-muted`. Tinggi minimum 32px, radius pill, font
`text-micro`.

`Kustom` membuka pemilih rentang tanggal dengan batas minimum satu bulan dan
maksimum satu tahun (DASH-8).

### 9.5 Kartu

| Jenis | Padding | Latar | Border | Radius |
| --- | --- | --- | --- | --- |
| Metrik | 20px | `surface` | `line` | `radius-card` |
| Metrik besar | 24px | `surface` | `line` + `shadow-brand` opsional | `radius-card` |
| Nested tile | 16px | `surface-2` | `line` | `radius-tile` |
| Panel | 20px | `surface` | `line` | `radius-card` |
| Baris daftar | 12px 20px | transparan | `line-soft` bawah saja | tanpa radius |

Anatomi kartu metrik: judul `text-card`, aksi opsional kanan atas, nilai
`text-metric`, delta `text-micro`, konteks `text-meta`. Kartu tidak boleh
memuat lebih dari dua nilai moneter.

Hover pada kartu yang bisa diklik: kartu bergerak `translateY(-2px)` dengan
`shadow-float`, durasi 240ms, `ease-soft`. Kartu yang tidak bisa diklik tidak
punya hover. Ini mencegah penanda interaksi palsu.

### 9.6 Baris Transaksi

```
[ikon kategori 32]  Deskripsi 13/400              Rp1.250.000  13/500 tabular
                     Kategori • metode • tanggal    2 hari lalu   10/400
```

| Token | Nilai |
| --- | --- |
| Tinggi minimum | 56px |
| Ikon | 32px, `radius-pill`, `surface-2`, warna `category.color_code` |
| Jarak ikon ke teks | 12px |
| Label nominal | `text-body` 500, `tabular-nums` |
| Meta | `text-meta` `ink-subtle` |
| Pemisah | `line-soft` 1px, hanya sisi bawah |

Keadaan baris: awan, kursor mendekat (`surface-2`), fokus (`outline-brand` di
dalam), terpilih (`brand-wash`), diarsipkan (`ink-faint`, tidak dapat dipilih).
Baris yang dapat dihapus memunculkan aksi pada hover, bukan selalu tampil.

### 9.7 Status Pill Anggaran

Tiga status sesuai BUD-6, ditambah status netral.

| Status | Latar | Teks | Border | Ikon |
| --- | --- | --- | --- | --- |
| Sehat (< 80%) | `positive` 12% | `positive` | `positive` 32% | Centang |
| Mendekati batas (80–100%) | `caution` 12% | `caution` | `caution` 32% | Segitiga peringatan |
| Melebihi batas (> 100%) | `negative` 12% | `negative` | `negative` 32% | Silang |
| Tercapai | `brand-wash` | `brand-soft` | `brand` 32% | Tanda centang ganda |

Bentuk ikon berbeda antar status agar makna tidak bergantung pada warna saja.
Teks pill selalu nama status lengkap, bukan hanya angka persentase.

### 9.8 Progress Bar

```html
<div class="h-1 w-full overflow-hidden rounded-pill bg-surface-3">
  <div class="h-full rounded-pill transition-[width] duration-500 ease-soft" style="width: 62%"></div>
</div>
```

| Status | Warna fill |
| --- | --- |
| Sehat | `positive` |
| Mendekati | `caution` |
| Melebihi | `negative` |
| Tercapai | `brand` |

Animasi lebar 500ms `ease-soft`, aman saat terpotong karena berbasis properti
lebar, bukan keyframes. Persentase selalu tampil sebagai teks di samping baris, tidak
pernah hanya visual.

### 9.9 Horizontal Accordion Anggaran

Komponen terpilih melalui randomisasi. Baris anggaran tertutup adalah baris
`text-body` dengan tinggi 48px. Hover memperluasnya dengan melebar
horizontal sampai 100% lebar baris, durasi 420ms `ease-emphasized`.

Isi yang tampil saat terbuka: judul kategori, nominal limit, nominal terpakai,
sisa, persentase utilisasi, progress bar, dan lima transaksi terakhir kategori
tersebut (BUD-4). Tinggi panel terbuka 232px.

Aturan: hanya satu baris terbuka pada satu waktu. Accordion tidak boleh
menjadi grid bento.

### 9.10 Marquee Kategori

Komponen terpilih melalui randomisasi. Strip berjalan tanpa henti pada modul
Analitik, tinggi 88px, lebar track 200% (duplikasi konten agar loop mulus).

```css
.marquee-track {
  display: flex;
  width: 200%;
  animation: var(--animate-marquee);
}

.marquee:hover .marquee-track,
.marquee:focus-within .marquee-track {
  animation-play-state: paused;
}

.marquee-track:hover {
  animation-play-state: paused;
}

@media (prefers-reduced-motion: reduce) {
  .marquee-track {
    animation: none;
    width: 100%;
    overflow-x: auto;
  }
}
```

Isi tiap chip: nama kategori, nominal pengeluaran bulan ini, dan persentase
proporsi (DASH-5). Marquee berhenti saat kursor mendekat atau saat fokus keyboard,
dan berhenti sepenuhnya pada mode gerak dikurangi.

### 9.11 Insight Carousel

Komponen terpilih melalui randomisasi. Satu kartu insight, tinggi tetap 232px,
tanpa nomor slide dan tanpa titik indikator.

Tiga keadaan yang mungkin terjadi: narasi sehat, mendekati batas, dan
melebihi batas.

| Keadaan | Judul | Isi | Aksi |
| --- | --- | --- | --- |
| Sehat | Anggaran terkendali | Enam dari enam pos masih di bawah 80% limit. | Lihat anggaran |
| Mendekati | Tiga kategori mendekati batas | Makanan 88%, Transportasi 91%, hiburan 94%. | Tinjau pos |
| Melebihi | Hiburan melebihi batas | Pengeluaran Rp4.210.000 dari limit Rp3.500.000. | Buka transaksi |

Kartu tidak menampilkan skor, persentase, atau klaim prediksi. Narasi
hanya menyatakan fakta hasil perhitungan BUD-4 sampai BUD-6.

Navigasi memakai dua tombol ikon 36px dengan `aria-label` dalam Bahasa
Indonesia. Navigasi keyboard memakai `ArrowLeft` dan `ArrowRight`, dengan
`aria-live="polite"` pada area narasi.

### 9.12 Tabel

| Elemen | Spesifikasi |
| --- | --- |
| Tinggi header | 44px |
| Tinggi baris | 52px |
| Padding | 12px 16px |
| Latar header | `surface-2`, `text-meta` `ink-subtle`, tanpa huruf kapital |
| Pemisah | `line-soft`, hanya horizontal, tidak ada garis vertikal |
| Zebra | Dilarang. Alternatif baris lewat hover |
| Numerik | Rata kanan, `tabular-nums`, `text-body` 500 |
| Teks | Rata kiri, `text-body` 400, ellipsis satu baris |
| Urut | Ikon di kanan header, `aria-sort`, keadaan naik dan turun |
| Sticky | Header menempel saat tabel panjang |
| Seleksi | Checkbox 18px, header indeterminate untuk sebagian terpilih |

Kolom minimum untuk tabel transaksi desktop: checkbox, tanggal, deskripsi,
kategori, metode, tipe, nominal, aksi. Di bawah `lg`, lima kolom pertama
berubah menjadi daftar kartu.

### 9.13 Dialog

| Elemen | Spesifikasi |
| --- | --- |
| Scrim | `canvas` 72%, `backdrop-blur(2px)` |
| Panel | `surface`, `radius-dialog`, `shadow-modal`, `border-line` |
| Lebar | 440px (form), 560px (konfirmasi panjang), 720px (form bertahap) |
| Padding | 24px |
| Judul | `text-section`, `ink` |
| Deskripsi | `text-body`, `ink-muted`, maks 2 baris sebelum ellipsis |
| Aksi | Kanan, `quiet` lalu `primary`, jarak 8px |
| Perangkap fokus | Aktif, fokus ke elemen pertama yang dapat difokuskan |
| Tombol Escape | Menutup dialog kecuali dialog yang sedang memproses |
| Scroll | Panel boleh scroll, footer sticky di dalam panel |

Dialog yang memproses mengunci tombol aksi dan menampilkan spinner pada tombol
konfirmasi. Kirim ganda tidak mungkin terjadi karena tombol nonaktif selama
permintaan berjalan.

### 9.14 Toast

Kiri bawah pada desktop, atas pada mobile. Tinggi 64px, `radius-card`, ikon
16px, judul `text-label`, deskripsi `text-meta`.

| Jenis | Ikon | Border |
| --- | --- | --- |
| Berhasil | Centang | `positive` 32% |
| Gagal | Silang | `negative` 32% |
| Peringatan | Segitiga | `caution` 32% |

Durasi 5 detik, dapat dijeda saat hover. `role="status"` untuk berhasil dan
`role="alert"` untuk gagal. Toast tidak pernah dipakai untuk pesan galat yang
membutuhkan tindakan pengguna.

### 9.15 Empty State

Tinggi minimum 240px. Ikon 40px `ink-faint` di dalam `radius-pill` 64px
`surface-2`. Judul `text-card` `ink`, deskripsi `text-body` `ink-muted` maks
320px, satu aksi `primary` atau `quiet`.

Copy yang benar: `Belum ada transaksi bulan ini` dengan aksi `Catat transaksi`.
Copy yang salah: `No data available`, `Kosong`, `Error 404`.

### 9.16 Skeleton

Skeleton mengikuti bentuk akhir komponen, bukan blok abu-abu generik. Baris
transaksi: avatar 32, dua baris teks 60% dan 40%, nominal 40% rata kanan.
Durasi shimmer 1400ms linear, atau `opacity` 0.55 tanpa gerak pada mode gerak
dikurangi. Skeleton tidak pernah memakai teks placeholder yang menyerupai data.

### 9.17 Avatar

Ukuran 24, 32, 40. Bentuk `radius-pill`. Tanpa foto: inisial `text-label`
500 dengan latar `brand-wash` dan teks `brand-soft`. Dengan foto: gambar
dikalangi `contrast-110 saturate-90`. Batas 2px `surface`.

### 9.18 Abstraksi Ikon

Prototipe mengulang SVG inline 12 kali. Semua ikon dipusatkan di
`assets/icons.svg` sebagai sprite, lalu dipakai lewat `<use>`:

```html
<svg class="size-[18px] text-ink-muted" aria-hidden="true"><use href="/assets/icons.svg#i-wallet"></use></svg>
```

Ikon yang wajib ada: dashboard, transaksi, anggaran, analitik, target,
pengaturan, bantuan, notifikasi, pencarian, tambah, filter, urutkan, chevron,
tutup, centang, silang, peringatan, rumah tangga. Stroke 1.5,
`linecap="round"`, `linejoin="round"`, `currentColor`, grid 24.

---

## 10. Spesifikasi Visualisasi Data

### 10.1 Aturan Umum

- Setiap grafik wajib memiliki tabel data sebagai alternatif aksesibel. Grafik
  tanpa tabel dianggap belum selesai pada DASH-7 dan DASH-8.
- Sumbu Y tidak pernah dimulai dari angka selain nol pada data nominal.
- Warna seri memakai `brand`, `brand-muted`, `positive`, `caution`, `negative`,
  `ink-subtle` dengan urutan tetap, bukan warna acak.
- Grid chart memakai `line-soft` 1px pada 25% tinggi.
- Label sumbu `text-axis` `ink-faint`. Nilai presisi selalu ada di tooltip dan
  tabel.

### 10.2 Line dan Area (DASH-7)

| Elemen | Spesifikasi |
| --- | --- |
| ViewBox | 1000 x 240, `preserveAspectRatio="none"` |
| Stroke | `brand` 2px, `vector-effect="non-scaling-stroke"` |
| Area fill | `linearGradient` `brand` 30% ke 0%, vertikal |
| Crosshair | 1px `ink-muted`, `dasharray="6 6"` |
| Titik | `brand-soft` r6, halo `brand` r12 opacity 18% |
| Tooltip | `overlay`, `radius-field` 10px, `shadow-float`, border `line` |
| Interaksi | Kursor dan keyboard keduanya memicu crosshair |
| Animasi | Path `stroke-dashoffset` 900ms `ease-emphasized` saat mount |

Prototipe memakai `preserveAspectRatio="none"` sehingga stroke ikut teregangkan
dan garis 2px berubah ketebalan saat jendela diubah. Perbaikan: hentikan
pemakaian `none`; ukuran chart ditentukan lewat CSS dengan rasio tetap
sehingga `viewBox` tidak mengubah bentuk stroke. Implementasi disarankan
memakai pustaka grafik yang menangani `devicePixelRatio` dengan benar, bukan
SVG mentah.

### 10.3 Donut Distribusi Kategori (DASH-5)

| Elemen | Spesifikasi |
| --- | --- |
| Diameter | 168px |
| Tebal cincin | 18px |
| Jarak antar iris | 3px |
| Label | Nama kategori `text-meta`, nominal `text-body` 500 tabular |
| Maksimum iris | 6, sisanya digabung menjadi `Lainnya` |
| Pusat | Total pengeluaran `text-figure`, label `text-micro` |

### 10.4 Bar Budget

Horizontal bar, tinggi 10px, radius pill, tinggi baris 40px. Latar `surface-3`.
Warna sesuai status BUD-6. Ambang 80% ditandai garis vertikal 1px
`caution` pada posisi 80% dengan label `text-axis` `caution`.

### 10.5 Waterfall Arus Kas (DASH-3)

Batang pemasukan `positive`, batang pengeluaran `negative`, batang net
`brand` atau `negative` sesuai arah. Sumbu X adalah bulan kalender, label
format `Jan` sampai `Des`. Nilai ditampilkan di tooltip dan tabel.

### 10.6 Angka Kunci Dashboard (DASH-1, DASH-2, DASH-3)

Empat kartu metrik dalam satu baris: Saldo total, Pemasukan bulan ini,
Pengeluaran bulan ini, Arus kas bersih. Susunan wajib:

```
grid gap-2.5 grid-cols-1 md:grid-cols-2 xl:grid-cols-4
```

Setiap kartu memuat nilai `text-metric`, delta berbanding periode sebelumnya,
dan sparkline 40px tinggi tanpa sumbu. Warna delta mengikuti arah, bukan
kebetulan tata letak.

---

## 11. Sistem Motion

Motion dibagi tiga jenjang. Hanya jenjang 1 dan 2 yang muncul di halaman
dashboard. Jenjang 3 hanya pada modul Analitik.

### 11.1 Jenjang 1 — Micro-interaction

CSS murni, tanpa JavaScript.

| Token | Durasi | Easing | Pemakaian |
| --- | --- | --- | --- |
| `motion-instant` | 80ms | `ease-soft` | Tombol ditekan |
| `motion-fast` | 160ms | `ease-soft` | Kursor, fokus, warna |
| `motion-base` | 240ms | `ease-soft` | Kartu, baris, chip |
| `motion-slow` | 320ms | `ease-emphasized` | Panel, drawer, dropdown |
| `motion-data` | 500ms | `ease-soft` | Bilah kemajuan, angka berhitung naik |

Durasi di atas 400ms tidak diizinkan saat kursor mendekat. Transisi yang dapat
dihentikan harus berbasis properti, bukan keyframes, sehingga pemotongan
berjalan bersih.

### 11.2 Jenjang 2 — Transisi Navigasi

Beralih halaman memakai View Transitions API dengan fallback
`rise`. Hanya opacity dan translate 10px yang dianimasikan. Durasi 320ms
`ease-emphasized`. Tidak ada slide horizontal pada perpindahan modul.

```js
const reduced = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

document.addEventListener("click", (event) => {
  const link = event.target.closest("[data-route]");
  if (!link || reduced || !document.startViewTransition) return;
  event.preventDefault();
  navigate(link.dataset.route);
});

function navigate(route) {
  if (!document.startViewTransition) return render(route);
  document.startViewTransition(() => render(route));
}
```

Modal memakai scale 0.98 ke 1 bersama opacity, 240ms `ease-emphasized`,
durasi keluar 160ms `ease-exit`.

### 11.3 Jenjang 3 — Motion berbasis Scroll

Hanya pada modul Analitik. Memerlukan GSAP 3 dengan ScrollTrigger.

**Scrubbed Text Reveal** untuk paragraf narasi Analitik.

```js
gsap.registerPlugin(ScrollTrigger);

if (!reduced) {
  document.querySelectorAll("[data-scrub-text]").forEach((element) => {
    const words = element.textContent.trim().split(/\s+/);
    element.textContent = "";
    words.forEach((word, index) => {
      const span = document.createElement("span");
      span.className = "inline-block";
      span.textContent = index < words.length - 1 ? word + " " : word;
      element.appendChild(span);
    });

    gsap.fromTo(
      element.querySelectorAll("span"),
      { opacity: 0.1 },
      {
        opacity: 1,
        ease: "none",
        stagger: 0.06,
        scrollTrigger: {
          trigger: element,
          start: "top 82%",
          end: "bottom 55%",
          scrub: 0.6
        }
      }
    );
  });
}
```

Nilai awal 0.1 membuat paragraf tetap terbaca sebelum disorot. Scrub 0.6
memberi jeda yang terasa fisik. Maksimal 40 kata per elemen.

**Card Stacking** untuk lima transaksi terbaru.

```js
if (!reduced) {
  document.querySelectorAll("[data-stack]").forEach((stack) => {
    const cards = stack.querySelectorAll("[data-stack-item]");

    gsap.fromTo(
      cards,
      {
        autoAlpha: 0,
        yPercent: (index) => 18 + index * 10,
        scale: 0.96
      },
      {
        autoAlpha: 1,
        yPercent: (index) => -index * 6,
        scale: 1,
        ease: "none",
        stagger: 0.08,
        scrollTrigger: {
          trigger: stack,
          start: "top 80%",
          end: "bottom 60%",
          scrub: 0.5
        }
      }
    );
  });
}
```

Hasilnya: kartu ditumpuk dari bawah dengan tumpang tindih 6% antar kartu.
Bayangan berkurang seiring kartu berpindah ke belakang, sehingga kedalaman
terbaca.

### 11.4 Reduced Motion sebagai Rantai Default

```css
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

GSAP harus memeriksa `prefers-reduced-motion` secara eksplisit sebelum
membuat ScrollTrigger, karena ScrollTrigger tidak dimatikan oleh CSS di atas.
Marquee dan angka yang menghitung naik wajib punya cabang non-animasi.

---

## 12. Peta Layar terhadap PRD

| Layar | Route | Kebutuhan PRD | Komponen dominan |
| --- | --- | --- | --- |
| Masuk | `/masuk` | AUTH-3, AUTH-5, AUTH-7 | Form tunggal, error aman |
| Daftar | `/daftar` | AUTH-1, AUTH-7 | Form, aturan password |
| Pemulihan | `/pulihkan` | AUTH-5 | Form, status terkirim |
| Dashboard | `/` | DASH-1..DASH-6 | Empat metrik, bento, grafik, tumpukan |
| Transaksi | `/transaksi` | TRX-1..TRX-9 | Tabel, filter, dialog form |
| Anggaran | `/anggaran` | BUD-1..BUD-8 | Accordion, bar anggaran, status pill |
| Target Tabungan | `/target` | SAV-1..SAV-8 | Kartu target, bilah kemajuan, riwayat |
| Analitik | `/analitik` | DASH-5, DASH-7, DASH-8 | Marquee, insight carousel, scrub reveal |
| Pengaturan | `/pengaturan` | PROF-1..PROF-5 | Form profil, pemilih tema |
| Bantuan | `/bantuan` | AUTH-6 (status sesi) | Teks bantuan, kontak |

### 12.1 Dashboard

Urutan baca wajib: total saldo, pemasukan, pengeluaran, arus kas bersih, tren
pengeluaran, distribusi kategori, anggaran approaching, transaksi terbaru,
ringkasan target.

| Permukaan | Data | Keadaan wajib |
| --- | --- | --- |
| Empat kartu metrik | DASH-1, DASH-2, DASH-3 | memuat, nol, galat |
| Tren bulanan | DASH-7 | memuat, satu titik, galat |
| Distribusi kategori | DASH-5 | memuat, satu kategori, galat |
| Insight carousel | BUD-4, BUD-6 | sehat, mendekati, melebihi |
| Transaksi terbaru | DASH-4 | memuat, kosong, galat |
| Ringkasan target | DASH-6 | memuat, tanpa target, galat |

Ringkasan target menampilkan maksimum tiga target aktif dengan bilah kemajuan
berwarna `positive`, `caution`, atau `brand` sesuai BUD-5 dan SAV-5.

### 12.2 Transaksi

| Kontrol | Perilaku | PRD |
| --- | --- | --- |
| Tombol utama di topbar | Membuka dialog transaksi baru | TRX-1 |
| Pencarian deskripsi | Debounce 300ms, operator `ilike` | TRX-4 |
| Filter tipe | Chip Pemasukan dan Pengeluaran | TRX-5 |
| Filter kategori | Dropdown, kembali ke semua saat tipe berubah | TRX-5 |
| Filter tanggal | Rentang awal akhir, default bulan berjalan | TRX-5 |
| Urut | Tanggal, nominal, dua arah | TRX-6 |
| Paginasi | Bawaan 20 baris, opsi 50 | TRX-3 |
| Ubah | Dialog terisi, kirim pembaruan | TRX-7 |
| Hapus | Dialog konfirmasi, nama transaksi pada konfirmasi | TRX-8 |

Kolom wajib: tanggal, deskripsi, kategori, metode pembayaran, tipe, nominal,
aksi. RLS membuat baris milik pengguna lain tidak pernah tampil; kegagalan
pencobaan akses tidak menghasilkan pesan error ke pengguna.

Dialog transaksi memvalidasi nominal lebih besar dari nol sebelum mengirim, dan
menerjemahkan pesan constraint PostgreSQL menjadi kalimat yang ramah
pembaca. Isian catatan dan metode pembayaran bersifat opsional.

### 12.3 Anggaran

| Permukaan | Aturan | PRD |
| --- | --- | --- |
| Daftar pos | Hanya kategori pengeluaran | BUD-1 |
| Pembuatan | Satu batas per kategori per periode | BUD-2 |
| Realisasi | Agregasi transaksi pengeluaran bulan berjalan | BUD-4 |
| Pemanfaatan | Sisa batas dan persentase, dua angka selalu | BUD-5 |
| Status | Tiga tingkat sesuai ambang 80% | BUD-6 |
| Ubah | Dialog inline, tanpa pindah halaman | BUD-7 |
| Hapus | Dialog konfirmasi | BUD-8 |

Periode anggaran ditentukan kalender WIB. Header daftar menampilkan periode
aktif dalam format `Mei 2026` dan kontrol berpindah periode ke bulan
sebelumnya atau sesudahnya. Konten yang tidak berubah saat berpindah periode
adalah kerangka tampilan, bukan data.

### 12.4 Target Tabungan

| Permukaan | Aturan | PRD |
| --- | --- | --- |
| Kartu target | Nama, nominal sasaran, terkumpul, sisa, persentase | SAV-2 |
| Kemajuan | Bilah `brand` berubah menjadi `positive` saat selesai | SAV-2, SAV-5 |
| Tambah kontribusi | Dialog nominal, tanggal, catatan | SAV-3 |
| Riwayat | Daftar kontribusi target terpilih | SAV-6 |
| Ubah | Nama, nominal, tenggat | SAV-7 |
| Hapus | Konfirmasi menyebut jumlah riwayat yang ikut terhapus | SAV-8 |

Dialog konfirmasi hapus wajib menyebutkan akibat secara eksplisit karena
SAV-8 menghapus riwayat kontribusi secara berjenjang. Status `Tercapai`
dibuat otomatis oleh basis data, bukan oleh klien; UI hanya menampilkannya.

### 12.5 Pengaturan

| Bagian | Isian | PRD |
| --- | --- | --- |
| Profil | Nama lengkap, email hanya-baca | PROF-1, PROF-2 |
| Tampilan | Pemilih tema terang atau gelap, tersimpan | PROF-3, PROF-4 |
| Mata uang | IDR, terkunci dengan label tetap | PROF-5 |
| Sesi | Keluar dari seluruh perangkat | AUTH-4 |

Email ditampilkan hanya-baca karena berasal dari Supabase Auth. Mengubah
email bukan bagian dari PRD MVP.

### 12.6 Auth

Layar autentikasi memakai satu kolom terpusat lebar 420px, bukan shell
aplikasi. Tidak ada navigasi modul pada layar ini. Galat autentikasi tidak
pernah menyebut apakah email terdaftar, selain pesan yang diminta AUTH-7.

---

## 13. Keadaan Sistem

Setiap permukaan data adalah fungsi dari lima keadaan berikut dan tidak boleh
melewati salah satunya.

| Keadaan | Perlakuan | Warna | Teks |
| --- | --- | --- | --- |
| Memuat | Skeleton sesuai bentuk akhir | netral | tanpa teks |
| Kosong | Empty state dengan satu aksi | netral | faktual, tanpa emoji |
| Galat | Pesan ringkas, kode teknis kecil, tombol coba lagi | `negative` | tanpa asumsi |
| Nol | Angka 0, bukan kosong | netral | `Rp0` |
| Berhasil | Toast non-pemblokir | `positive` | fakta perubahan |

Aturan tambahan:

- Galat selalu menyebut tindakan pemulihannya, bukan hanya penyebabnya.
- Keadaan kosong pada modul berbeda memiliki teks berbeda. `Belum ada transaksi` bukan
  jawaban yang benar untuk `Belum ada anggaran`.
- Angka nol wajib dirender sebagai `Rp0`, bukan blank, bukan `-`.
- Kegagalan sebagian pada agregasi dashboard menampilkan nilai yang berhasil
  diambil dan menandai nilai yang gagal secara individual, bukan menyembunyikan
  seluruh panel.

---

## 14. Aturan Konten dan Lokalisasi

### 14.1 Format Nilai

```js
const currency = new Intl.NumberFormat("id-ID", {
  style: "currency",
  currency: "IDR",
  minimumFractionDigits: 0,
  maximumFractionDigits: 0
});

const compact = new Intl.NumberFormat("id-ID", {
  notation: "compact",
  maximumFractionDigits: 1
});

const dateShort = new Intl.DateTimeFormat("id-ID", {
  day: "numeric",
  month: "short",
  year: "numeric",
  timeZone: "Asia/Jakarta"
});

const monthYear = new Intl.DateTimeFormat("id-ID", {
  month: "long",
  year: "numeric",
  timeZone: "Asia/Jakarta"
});
```

Hasil yang diharapkan: `Rp12.304.110`, `Rp0`, `12 Jun 2025`, `Juni 2025`.
Bukan `$12,304.11`, bukan `12,304`, bukan `Rp 12.304.110`.

### 14.2 Presisi Numerik dari Basis Data

Kolom `numeric` PostgreSQL dikirim sebagai string untuk menjaga presisi.
Aturan:

```js
const toNumber = (value) => Number.parseFloat(String(value ?? "0"));
```

Jangan pernah memakai `parseInt` untuk nominal. Tailwind dan CSS tidak boleh
melakukan pembulatan pada nilai yang ditampilkan, karena nilai yang tampil
harus sama dengan nilai yang tersimpan.

### 14.3 Tanggal dan Zona Waktu

- Seluruh `created_at` dan `updated_at` disimpan UTC ISO-8601.
- Seluruh batas periode bulanan dihitung pada `Asia/Jakarta`.
- Transaksi tidak pernah mengizinkan tanggal transaksi lebih dari hari ini.
- Tanggal transaksi di masa depan ditolak oleh check constraint basis data,
  bukan hanya oleh UI.

### 14.4 Penulisan Label

| Konteks | Benar | Salah |
| --- | --- | --- |
| Kategori | `Makanan dan Minuman` | `Makan` |
| Metode | `Transfer bank`, `QRIS`, `Tunai` | `BCA`, `GOPAY` |
| Periode | `Juni 2026` | `Jun 26`, `06/2026` |
| Status anggaran | `Mendekati batas` | `Waspada`, `Hati-hati` |
| Aksi | `Catat transaksi` | `Tambah baru`, `Submit` |
| Hapus | `Hapus transaksi ini` | `Hapus?`, `Yakin hapus?` |

Tidak ada onboarding keadaan kosong yang berupa pertanyaan. Kalimat tanya hanya
muncul di dalam dialog konfirmasi, dan kalimatnya berupa pernyataan.

---

## 15. Kontrak Aksesibilitas

| Aspek | Aturan |
| --- | --- |
| Kontras teks | Minimal 4.5:1, teks besar 3:1, semua kombinasi di 5.2 terukur |
| Kontras non-teks | Batas kontrol wajib 3:1 memakai `line-control` |
| Fokus terlihat | 2px `brand`, offset 2px, tidak pernah dihapus |
| Urutan fokus | Mengikuti urutan visual, tidak pernah lompat |
| Landmark | `nav`, `main`, `aside`, `header` dengan label |
| Navigasi keyboard | Sidebar, tab, dialog, tabel, carousel, accordion |
| Pembaca layar | Grafik selalu punya tabel alternatif dengan caption |
| Area langsung | Toast `role="status"`, galat `role="alert"`, carousel `polite` |
| Target sentuh | Minimal 44x44px pada semua kontrol interaktif |
| Label form | Semua isian punya `label` yang terikat, bukan placeholder sebagai label |
| Validasi | Galat dikaitkan dengan `aria-describedby` dan `aria-invalid="true"` |
| Gerak | `prefers-reduced-motion` mematikan semua gerakan, termasuk GSAP |
| Zoom | Dapat digunakan hingga 200% tanpa kehilangan fungsi |
| Kontras paksa | Border dan keadaan tetap terdeteksi |

Setiap halaman harus dapat dioperasikan penuh dengan keyboard saja, termasuk
membuka dialog, mengonfirmasi penghapusan, dan berpindah grafik ke tabel.

---

## 16. Anti-Pattern yang Dilarang

| Dilarang | Alasan | Yang benar |
| --- | --- | --- |
| `text-white` di atas `brand` pada tema terang | Kontras tidak terukur | `text-brand-ink` |
| Nilai hex di dalam `className` | Sistem token runtuh | Token semantik |
| Label meta `Section 01`, `Step 2` | Terlihat murah | Nama isi sebenarnya |
| Emoji di UI atau dokumen | Tidak profesional, tidak konsisten | Ikon SVG atau teks |
| `gradient-to-r` pada teks | Kontras tidak stabil | Warna solid |
| Border di keempat sisi kartu | Terlihat tebal | `border` tunggal plus warna permukaan |
| Tinggi tetap pada kartu data | Memotong data | Tinggi natural |
| `grid` tanpa pemeriksaan rongga | Ruang kosong terlihat | `grid-rows-[auto_1fr]` |
| Skeleton abu-abu generik | Terputus dari bentuk akhir | Skeleton sesuai bentuk |
| `Rp` di dalam `value` input | Menyulitkan pengisian angka | Awalan visual saja |
| Format AS `$1,234.56` | Melanggar PROF-5 | `Rp1.235` |
| Animasi lebih dari 400ms saat kursor mendekat | Terasa lambat | `motion-base` 240ms |
| `overflow-x` pada halaman | Memunculkan bilah gulir horizontal | `overflow-x-hidden` pada elemen akar |
| Toast untuk galat yang perlu tindakan | Tidak ada jalan keluar | Galat sebaris |
| Kontras teks dari `ink-faint` | 4.03:1 gagal AA | `ink-subtle` |
| Sorotan saat gulir tanpa penjaga reduced motion | Gagal aksesibilitas | Cek `matchMedia` |

---

## 17. Gate Implementasi

Tidak ada layar yang dianggap selesai tanpa melewati semua gate berikut.

| Gate | Pemeriksaan |
| --- | --- |
| Token | `rg` tidak menemukan hex, rem, atau durasi di luar `@theme` |
| Bahasa | Tidak ada string UI berbahasa Inggris selain nama produk |
| Mata uang | Tidak ada simbol `$` di seluruh sumber |
| Tipografi | Tidak ada `text-[Npx]`; semua dari skala |
| Radius | Tidak ada `rounded-[Npx]`; semua dari skala |
| Grid | Setiap baris bento menutupi lebar penuh, `grid-flow-dense` pada grid tidak seragam |
| Kontras | Semua pasangan warna terukur minimal 4.5:1 |
| Fokus | Tabulasi melewati seluruh kontrol dengan ring terlihat |
| Keadaan | Lima keadaan dari Bab 13 tersedia di setiap permukaan data |
| Aksesibilitas data | Setiap grafik punya tabel alternatif |
| RLS | Setiap permintaan data memakai sesi JWT; tidak ada service-role key di bundel |
| Reduced motion | Dilatih dengan `prefers-reduced-motion: reduce` aktif |
| Viewport | Diuji pada 360, 768, 1280, 1440 |
| Performa | Kueri agregasi di bawah 200ms pada beban normal |

---

## 18. Urutan Pengerjaan yang Disarankan

| Fase | Cakupan | PRD |
| --- | --- | --- |
| 1 | Token, tema, shell, sidebar, topbar | — |
| 2 | Auth masuk, daftar, pemulihan | AUTH-1..AUTH-7 |
| 3 | Shell dashboard dengan data contoh dari berkas lokal | DASH-1..DASH-8 |
| 4 | Koneksi Supabase, sesi, RLS, CRUD transaksi | TRX-1..TRX-9 |
| 5 | Anggaran beserta kalkulasi status | BUD-1..BUD-8 |
| 6 | Target tabungan dan kontribusi atomik | SAV-1..SAV-8 |
| 7 | Kategori sistem dan profil | CAT-1..CAT-3, PROF-1..PROF-5 |
| 8 | Analitik, marquee, insight carousel, gerakan saat gulir | DASH-7, DASH-8 |
| 9 | Pengaturan tema persisten, logout, bantuan | PROF-3, AUTH-4 |

Setiap fase mengimplementasikan keadaan Bab 13 sejak awal. Menunda penanganan
keadaan sampai akhir hanya mengulang kegagalan yang sekarang terjadi pada
`index.html`.

---

## 19. Pertanyaan Terbuka yang Harus Diputuskan

Daftar ini menerjemahkan Bab 12 PRD menjadi keputusan yang dibutuhkan desain.

| Pertanyaan | Dampak desain | Usulan bawaan |
| --- | --- | --- |
| Ukuran halaman bawaan | Tinggi tabel, jumlah kontrol paginasi | 20 baris, opsi 20/50/100 |
| Daftar kategori sistem | Ikon dan warna pada tabel, donut, marquee | 6 pengeluaran, 3 pemasukan, warna dari palet status |
| Verifikasi email saat pendaftaran | Alur setelah daftar | Konfirmasi email aktif, dengan layar menunggu konfirmasi |
| Hapus target dengan saldo | Teks konfirmasi | Konfirmasi eksplisit menyebut jumlah kontribusi yang terhapus |
| Periode anggaran | Komponen periode | Kalender, tanpa siklus kustom |
| Periode ringkasan grafik | Chip filter | Bulanan, kuartalan, tahunan |
| Mata uang lain | Format dan simbol | IDR saja, terkunci (PROF-5) |

---

## 20. Ringkasan Keputusan

Randomisasi deterministik dengan seed 40 memilih satu sumbu optik terpusat,
tipografi Cabinet Grotesk, tiga komponen khas berupa Horizontal Accordion
anggaran, Marquee kategori, dan Insight Carousel berbasis status, serta dua
pola gerakan berupa Scrubbed Text Reveal dan Card Stacking. Seluruh pilihan
tersebut dijaga oleh gate Bab 17 dan tidak dapat mengorbankan lima keadaan data,
kontras 4.5:1, presisi IDR, atau aturan main yang dituangkan dalam PRD.