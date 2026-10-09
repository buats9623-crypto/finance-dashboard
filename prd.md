# PRODUCT REQUIREMENTS DOCUMENT (PRD)

## Personal Finance

**STATUS: DRAFT SEMENTARA**

| | |
| --- | --- |
| **Nama Produk** | Personal Finance Web Application |
| **Versi Dokumen** | v0.1 |
| **Disusun oleh** | Senior Backend Architect & Database Requirements Specialist (Pengembang) |
| **Untuk** | AI Coding Agent & Tim Pengembang Antarmuka (Klien) |
| **Tanggal** | 24 Mei 2024 |
| **Dokumen Terkait** | Spesifikasi Kebutuhan UI-First - Personal Finance |

---

# 1. Ringkasan Produk (Overview)

Pengelolaan keuangan pribadi sering kali menjadi kendala bagi mahasiswa, pekerja awal, dan individu yang memiliki anggaran mandiri. Metode pencatatan manual, lembar kerja spreadsheet yang rumit, atau aplikasi konvensional yang kaku kerap menimbulkan beban kognitif tinggi dan risiko kesalahan data. Tanpa sistem yang terintegrasi dan aman, pengguna kesulitan memantau mutasi arus kas harian, terlambat mengidentifikasi terjadinya pembengkakan pengeluaran terhadap batas anggaran bulanan, serta kehilangan konsistensi dalam merealisasikan target tabungan jangka panjang.

Personal Finance hadir sebagai aplikasi web manajemen keuangan pribadi yang andal, aman, dan presisi dengan pendekatan pengembangan antarmuka terpadu (UI-First Development). Sistem ini mengintegrasikan antarmuka pengguna yang telah ditentukan dengan backend berbasis Supabase dan PostgreSQL yang mencakup modul Autentikasi & Profil, Manajemen Kategori, Manajemen Transaksi, Manajemen Anggaran, Target Tabungan & Kontribusi, Dashboard, serta Analitik Keuangan. Didukung keamanan Row Level Security (RLS) dan kalkulasi finansial berbasis basis data, sistem ini menjamin integritas data transaksi dan transparansi posisi finansial pengguna secara akurat dan seketika.

# 2. Tujuan & Sasaran (Goals)

- Memusatkan seluruh pencatatan transaksi, pos anggaran bulanan, dan rencana tabungan pengguna ke dalam satu basis data relasional yang terstruktur, aman, dan konsisten.
- Mengurangi risiko anomali data dan inkonsistensi saldo melalui aturan integritas referensial dan kalkulasi moneter tingkat basis data.
- Menyediakan data analitik arus kas serta perbandingan pendapatan terhadap pengeluaran yang tepat untuk mendukung pengambilan keputusan finansial pengguna.
- Memberikan transparansi realisasi belanja terhadap plafon anggaran per kategori guna mencegah terjadinya pengeluaran berlebih (overspending).
- Memfasilitasi pelacakan progres akumulasi target tabungan secara terukur melalui pencatatan riwayat kontribusi yang terverifikasi.
- Mengamankan data pribadi dan riwayat transaksi setiap pengguna secara ketat melalui isolasi data berbasis Row Level Security (RLS).

# 3. Pengguna & Peran (Users & Roles)

- **Pelajar & Mahasiswa :** Pengguna akhir yang mengelola dana saku bulanan, mencatat pengeluaran harian, memantau batas jajan per kategori, dan menyisihkan dana untuk kebutuhan studi atau pembelian perangkat.
- **Individu & Profesional Mandiri :** Pengguna akhir dengan penghasilan mandiri atau rutin yang mengalokasikan anggaran untuk pos pengeluaran tetap, memantau arus kas bulanan, serta mengelola tabungan jangka panjang atau dana darurat.
- **Authenticated User (Sistem) :** Entitas pengguna terdaftar dan terverifikasi dalam sistem Supabase Auth yang memiliki hak penuh untuk membaca, menambah, mengubah, dan menghapus (CRUD) seluruh data transaksi, anggaran, target tabungan, serta preferensi profil miliknya sendiri.

# 4. Ruang Lingkup (Scope)

## 4.1 Termasuk (MVP)

- Modul Autentikasi & Akun: Registrasi pengguna, login berbasis email dan kata sandi, logout, pemulihan sesi, reset kata sandi, dan pemetaan profil pengguna terotentikasi.
- Modul Kategori Transaksi: Penyediaan kategori bawaan sistem untuk pemasukan dan pengeluaran beserta metadata ikon dan warna.
- Modul Manajemen Transaksi: Pencatatan, pembacaan, pengubahan, dan penghapusan transaksi (pemasukan/pengeluaran) dengan dukungan pencarian deskripsi, penyaringan kategori/tipe/tanggal, pengurutan, dan paginasi.
- Modul Manajemen Anggaran: Penetapan batas anggaran bulanan per kategori, kalkulasi realisasi belanja kategori, penghitungan sisa anggaran, dan penentuan status kesehatan anggaran (sehat, mendekati batas, melebihi batas).
- Modul Target Tabungan & Kontribusi: Pencatatan target tabungan baru, pembaruan data target, pencatatan riwayat kontribusi setoran dana, serta kalkulasi otomatis persentase kemajuan dan status penyelesaian target.
- Modul Dashboard & Analitik: Penyajian data agregasi saldo total, total pemasukan, total pengeluaran, arus kas bersih bulanan, transaksi terkini, serta grafik tren pengeluaran dan distribusi kategori.
- Keamanan & Integritas Basis Data: Penerapan Row Level Security (RLS) pada seluruh tabel data milik pengguna, validasi kendala (constraints) PostgreSQL, dan penanganan transaksi atomik.

## 4.2 Di Luar Lingkup Awal / Fase Lanjutan

Penyambungan otomatis mutasi perbankan/e-wallet via Open Finance aggregator, penyimpanan fisik bukti transaksi (struk/nota belanja) ke cloud storage, pengiriman notifikasi pintar eksternal (email/push notification), kustomisasi mandiri kategori oleh pengguna, serta fitur ekspor laporan ke format PDF atau spreadsheet ditunda untuk pengembangan tahap selanjutnya (rujuk ke Bab 11).

# 5. Asumsi & Batasan (Assumptions & Constraints)

- **Fondasi Teknologi Backend:** Backend diimplementasikan menggunakan layanan Supabase (PostgreSQL, Supabase Auth, Row Level Security, dan PostgREST) tanpa server monolitik terpisah untuk MVP.
- **Batasan Integrasi Kunci Keamanan:** Frontend hanya diizinkan berkomunikasi dengan Supabase menggunakan anon/public key dengan proteksi RLS; penggunaan service-role key di lingkungan browser dilarang keras.
- **Presisi Nilai Finansial:** Seluruh nilai moneter (nominal transaksi, alokasi anggaran, dan target tabungan) wajib menggunakan tipe data numerik eksak PostgreSQL (`numeric`/`decimal`) dan dilarang menggunakan tipe floating-point (`float`/`real`) guna menghindari galat presisi pembulatan.
- **Konvensi Mata Uang:** Format mata uang dikonfigurasikan secara bawaan ke Rupiah Indonesia (IDR) sesuai kebutuhan tampilan frontend.
- **Pendekatan Desain Integrasi (UI-First):** Struktur entitas backend, parameter kueri, dan format balasan diselaraskan dengan kontrak kebutuhan data yang telah ditetapkan pada antarmuka frontend yang sudah ada.
- **Isolasi Data Tingkat Baris:** Setiap tabel yang menyimpan data pengguna wajib memiliki referensi `user_id` yang terikat ke `auth.users` dengan kebijakan RLS aktif untuk operasi SELECT, INSERT, UPDATE, dan DELETE.
- **Penyimpanan Berkas (Supabase Storage):** Supabase Storage tidak diaktifkan pada tahap MVP ini karena lampiran bukti transaksi ditunda ke fase lanjutan.
- **Kalkulasi Finansial Kompleks:** *(Asumsi Pengembang)* Agregasi data yang memerlukan konsistensi tinggi atau pemrosesan multi-tabel (seperti ringkasan saldo dashboard dan atomisitas setoran tabungan) diasumsikan dijalankan melalui database views atau fungsi tersimpan (RPC/PostgreSQL functions) guna menjaga efisiensi kueri dari sisi klien.
- **Penetapan Ambang Batas Anggaran:** *(Asumsi Pengembang)* Status anggaran "Mendekati Batas" (*Approaching Limit*) diasumsikan dipicu ketika realisasi pengeluaran telah mencapai 80% hingga 100% dari alokasi bujet kategori pada bulan berjalan.
- **Zona Waktu Finansial:** *(Asumsi Pengembang)* Seluruh perhitungan agregasi bulanan diasumsikan menggunakan basis zona waktu lokal Indonesia (WIB / UTC+7) pada penentuan batas awal dan akhir bulan kalender.

# 6. Kebutuhan Fungsional (Functional Requirements)

## 6.1 Authenticated User - Autentikasi & Manajemen Akun

| **ID** | **Kebutuhan Fungsional** | **Prioritas** |
| --- | --- | --- |
| **AUTH-1** | Pengguna dapat mendaftarkan akun baru menggunakan email dan kata sandi valid melalui Supabase Auth. | **Wajib** |
| **AUTH-2** | Sistem secara otomatis mengeksekusi fungsi basis data (*trigger*) untuk membuat entitas data profil baru pada tabel `profiles` segera setelah akun pengguna baru tercatat di `auth.users`. | **Wajib** |
| **AUTH-3** | Pengguna dapat masuk (*login*) ke dalam sistem menggunakan kombinasi email dan kata sandi yang terdaftar untuk memperoleh token sesi (*JWT session*). | **Wajib** |
| **AUTH-4** | Pengguna dapat mengakhiri sesi (*logout*) yang mencabut validitas token sesi pada sisi klien dan server. | **Wajib** |
| **AUTH-5** | Pengguna dapat meminta tautan pemulihan kata sandi (*password reset*) melalui email yang terdaftar. | **Wajib** |
| **AUTH-6** | Sistem memvalidasi token sesi pengguna pada setiap permintaan data dan menolak akses jika sesi telah kedaluwarsa atau tidak valid. | **Wajib** |
| **AUTH-7** | Sistem menolak upaya registrasi jika alamat email sudah terdaftar sebelumnya dengan pesan galat yang aman. | **Wajib** |

## 6.2 Authenticated User - Profil & Pengaturan

| **ID** | **Kebutuhan Fungsional** | **Prioritas** |
| --- | --- | --- |
| **PROF-1** | Pengguna dapat membaca data profil miliknya sendiri, mencakup nama lengkap, email, preferensi mata uang, dan tema tampilan. | **Wajib** |
| **PROF-2** | Pengguna dapat memperbarui nama lengkap pada data profil miliknya. | **Wajib** |
| **PROF-3** | Pengguna dapat memperbarui preferensi tema tampilan (*light* atau *dark*) yang tersimpan secara persisten di basis data. | **Wajib** |
| **PROF-4** | Pengguna dapat mengonfigurasi preferensi tampilan informasi keuangan pada menu pengaturan akun. | **Penting** |
| **PROF-5** | Sistem mengunci format mata uang bawaan profil ke Rupiah Indonesia (IDR) sesuai konfigurasi MVP. | **Wajib** |

## 6.3 Authenticated User - Manajemen Kategori

| **ID** | **Kebutuhan Fungsional** | **Prioritas** |
| --- | --- | --- |
| **CAT-1** | Pengguna dapat membaca daftar seluruh kategori bawaan sistem (*system categories*) yang dipisahkan berdasarkan tipe pemasukan (*income*) dan pengeluaran (*expense*). | **Wajib** |
| **CAT-2** | Sistem menyajikan metadata visual kategori mencakup nama kategori, pengenal ikon (*icon identifier*), dan kode warna visual (*hex color*). | **Wajib** |
| **CAT-3** | Sistem mencegah manipulasi, pengubahan, atau penghapusan kategori bawaan sistem oleh pengguna reguler. | **Wajib** |
| **CAT-4** | Pengguna dapat menambahkan kategori pengeluaran dan pemasukan mandiri (*custom category*) yang terikat secara eksklusif ke `user_id` pemiliknya. | **Fase 2** |

## 6.4 Authenticated User - Manajemen Transaksi

| **ID** | **Kebutuhan Fungsional** | **Prioritas** |
| --- | --- | --- |
| **TRX-1** | Pengguna dapat mencatat transaksi baru dengan tipe pemasukan (*income*) atau pengeluaran (*expense*), nominal moneter bernilai positif, tanggal, kategori valid, deskripsi, metode pembayaran, dan catatan opsional. | **Wajib** |
| **TRX-2** | Sistem menolak pencatatan transaksi jika nominal bernilai nol atau negatif, tanggal tidak valid, atau kategori tidak ditemukan dalam basis data. | **Wajib** |
| **TRX-3** | Pengguna dapat membaca daftar riwayat transaksi miliknya dengan dukungan pemilahan berbasis paginasi (*limit* dan *offset*). | **Wajib** |
| **TRX-4** | Pengguna dapat mencari data transaksi berdasarkan kecocokan kata kunci pada teks deskripsi transaksi. | **Wajib** |
| **TRX-5** | Pengguna dapat menyaring (*filter*) riwayat transaksi berdasarkan tipe transaksi (pemasukan/pengeluaran), rentang tanggal, dan id kategori. | **Wajib** |
| **TRX-6** | Pengguna dapat mengurutkan (*sort*) daftar transaksi berdasarkan tanggal (terbaru/terlama) dan nominal transaksi (terbesar/terkecil). | **Penting** |
| **TRX-7** | Pengguna dapat memperbarui rincian data transaksi yang sudah tercatat sebelumnya. | **Wajib** |
| **TRX-8** | Pengguna dapat menghapus transaksi tertentu miliknya dari basis data. | **Wajib** |
| **TRX-9** | Sistem memastikan operasi pembaruan dan penghapusan transaksi hanya dapat dieksekusi terhadap data transaksi milik pengguna yang bersangkutan via RLS. | **Wajib** |

## 6.5 Authenticated User - Manajemen Anggaran

| **ID** | **Kebutuhan Fungsional** | **Prioritas** |
| --- | --- | --- |
| **BUD-1** | Pengguna dapat menetapkan alokasi batas anggaran bulanan baru untuk kategori pengeluaran tertentu pada periode bulan dan tahun yang ditentukan. | **Wajib** |
| **BUD-2** | Sistem menerapkan pembatasan unik (*unique constraint*) sehingga satu kategori hanya boleh memiliki satu batasan anggaran per periode bulan dan tahun untuk pengguna yang sama. | **Wajib** |
| **BUD-3** | Pengguna dapat membaca daftar seluruh anggaran aktif pada periode bulan berjalan beserta nominal batas anggaran yang dialokasikan. | **Wajib** |
| **BUD-4** | Sistem mengalkulasi total realisasi pengeluaran aktual per kategori anggaran berdasarkan agregasi data transaksi pengeluaran pada rentang bulan kalender yang bersangkutan. | **Wajib** |
| **BUD-5** | Sistem menghitung sisa batas anggaran (*remaining budget*) dan persentase pemanfaatan anggaran (*utilization percentage*) secara deterministik. | **Wajib** |
| **BUD-6** | Sistem menentukan status kesehatan anggaran dalam tiga level terukur: "Pengeluaran Sehat" (utilisasi < 80%), "Mendekati Batas" (utilisasi 80% - 100%), dan "Melebihi Batas" (utilisasi > 100%). | **Wajib** |
| **BUD-7** | Pengguna dapat mengubah nominal batas anggaran kategori yang telah didaftarkan pada periode berjalan. | **Wajib** |
| **BUD-8** | Pengguna dapat menghapus alokasi anggaran kategori yang tidak lagi digunakan. | **Wajib** |

## 6.6 Authenticated User - Target Tabungan & Kontribusi

| **ID** | **Kebutuhan Fungsional** | **Prioritas** |
| --- | --- | --- |
| **SAV-1** | Pengguna dapat membuat data target tabungan baru dengan menentukan nama target, nominal target sasaran dana, dan batas tanggal pencapaian (*target date*). | **Wajib** |
| **SAV-2** | Pengguna dapat membaca daftar seluruh target tabungan miliknya beserta nominal target, akumulasi simpanan saat ini, sisa kekurangan nominal, persentase kemajuan, dan status target. | **Wajib** |
| **SAV-3** | Pengguna dapat mencatat kontribusi setoran dana baru ke dalam target tabungan tertentu dengan menyertakan nominal setoran, tanggal kontribusi, dan catatan opsional. | **Wajib** |
| **SAV-4** | Sistem memperbarui akumulasi dana target tabungan (`current_amount`) secara otomatis dan atomik melalui prosedur basis data saat kontribusi baru berhasil dicatat. | **Wajib** |
| **SAV-5** | Sistem secara otomatis mengubah status target tabungan menjadi "Tercapai" (*Completed*) ketika total akumulasi simpanan telah mencapai atau melampaui nominal sasaran dana. | **Wajib** |
| **SAV-6** | Pengguna dapat membaca riwayat transaksi kontribusi dana yang terkait dengan target tabungan tertentu. | **Wajib** |
| **SAV-7** | Pengguna dapat memperbarui rincian informasi nama target, nominal sasaran, dan tenggat waktu target tabungan. | **Wajib** |
| **SAV-8** | Pengguna dapat menghapus data target tabungan beserta seluruh catatan riwayat kontribusi yang terhubung (*cascading delete* aman). | **Wajib** |

## 6.7 Authenticated User - Dashboard & Analitik Finansial

| **ID** | **Kebutuhan Fungsional** | **Prioritas** |
| --- | --- | --- |
| **DASH-1** | Sistem menyediakan fungsi agregasi (*RPC/Database View*) untuk menghitung total saldo kumulatif (selisih seluruh total pemasukan dikurangi seluruh total pengeluaran historis). | **Wajib** |
| **DASH-2** | Sistem menyediakan ringkasan total pemasukan dan total pengeluaran pada periode bulan berjalan pengguna. | **Wajib** |
| **DASH-3** | Sistem menyediakan data arus kas bersih (*net cash flow*) bulanan sebagai selisih pemasukan terhadap pengeluaran bulan berjalan. | **Wajib** |
| **DASH-4** | Sistem menyajikan daftar 5 transaksi terbaru milik pengguna untuk kebutuhan kartu ringkasan dashboard. | **Wajib** |
| **DASH-5** | Sistem menyediakan data distribusi proporsi nominal pengeluaran berdasarkan pengelompokan kategori pada rentang bulan berjalan. | **Wajib** |
| **DASH-6** | Pengguna dapat membaca ringkasan kemajuan akumulasi seluruh target tabungan aktif pada tampilan ringkasan dashboard. | **Wajib** |
| **DASH-7** | Sistem menyediakan fungsi analitik tren transaksi harian dan mingguan dalam rentang periode yang ditentukan pengguna untuk visualisasi grafik. | **Wajib** |
| **DASH-8** | Pengguna dapat meminta data agregasi analitik berdasarkan rentang waktu fleksibel (bulanan, kuartalan, atau tahunan). | **Penting** |

# 7. Alur Pengguna Utama (Key User Flows)

## 7.1 Pendaftaran Akun, Pembuatan Profil Otomatis, dan Sesi Login

1. Pengguna membuka antarmuka registrasi dan menginput alamat email serta kata sandi.
2. Frontend mengirimkan permintaan pendaftaran akun baru ke endpoint `supabase.auth.signUp()`.
3. Sistem Supabase Auth memvalidasi data dan mencatat rekaman identitas baru ke dalam tabel internal `auth.users` dengan status awal "Terkonfirmasi" atau "Menunggu Verifikasi Email".
4. *Trigger* basis data PostgreSQL (`on_auth_user_created`) terpicu secara otomatis di level basis data untuk menginisialisasi baris data baru pada tabel `public.profiles` dengan menyalin nilai `user_id`, email, nama default, serta pengaturan preferensi awal (`currency_code = 'IDR'`, `theme_preference = 'light'`).
5. Jika pendaftaran berhasil, pengguna diarahkan ke alur masuk (*login*) dengan memasukkan email dan kata sandi via `supabase.auth.signInWithPassword()`.
6. Supabase mengembalikan token akses JWT (*JSON Web Token*) yang valid ke klien, dan sistem mengubah status autentikasi klien menjadi "Terotentikasi".
7. *Pengecualian*: Jika email sudah terdaftar sebelumnya atau format data tidak memenuhi syarat, sistem mengembalikan pesan galat autentikasi, status tetap "Belum Terotentikasi", dan frontend menampilkan pesan kesalahan yang relevan.

## 7.2 Pencatatan dan Validasi Transaksi Baru dengan Pembaruan Agregasi

1. Pengguna membuka modal penambahan transaksi, memilih tipe transaksi "Pengeluaran", menginput nominal dana, memilih kategori pengeluaran, memilih tanggal transaksi, memilih metode pembayaran, serta menambahkan deskripsi belanja.
2. Frontend memverifikasi validitas format dasar input klien (status formulir "Valid").
3. Frontend mengirimkan kueri penyisipan data ke tabel `transactions` menggunakan Supabase Client SDK dengan menyertakan token JWT pengguna.
4. Mesin PostgreSQL memvalidasi kepemilikan data melalui kebijakan Row Level Security (RLS) `INSERT` yang memastikan `auth.uid() = user_id`.
5. Kendala basis data (*database constraints*) memvalidasi bahwa kolom `amount > 0` dan tipe transaksi bernilai valid (`income` atau `expense`).
6. Basis data berhasil menyimpan baris transaksi baru dengan status operasi "Sukses Tersimpan".
7. Perubahan data ini secara otomatis merefleksikan nilai mutasi pada pembacaan saldo total, ringkasan pengeluaran bulanan, dan sisa alokasi anggaran kategori terkait saat modul Dashboard atau Transaksi memuat ulang data.
8. *Pengecualian*: Jika nominal transaksi bernilai `<= 0` atau foreign key `category_id` tidak valid, PostgreSQL menolak kueri dengan galat kendala integritas (*constraint violation*), status operasi berubah menjadi "Gagal Diproses", dan frontend menangkap galat untuk menampilkan pesan peringatan.

## 7.3 Pemantauan Batas Anggaran dan Deteksi Pembengkakan (Overspending)

1. Pengguna mengakses modul "Manajemen Anggaran" untuk meninjau status anggaran kategori pada bulan kalender berjalan.
2. Frontend memanggil fungsi basis data atau view agregasi anggaran (`get_user_budget_summary`) untuk bulan dan tahun aktif dengan parameter konteks pengguna terautentikasi.
3. Basis data menghitung jumlah nominal dari seluruh transaksi pengeluaran (`type = 'expense'`) yang terjadi pada rentang awal hingga akhir bulan berjalan untuk setiap kategori yang memiliki alokasi bujet.
4. Sistem membandingkan nilai realisasi belanja aktual (`spent_amount`) terhadap nominal plafon alokasi (`monthly_limit`):
   - Jika rasio pengeluaran < 80%, sistem menetapkan status evaluasi kategori sebagai "Pengeluaran Sehat".
   - Jika rasio pengeluaran berada di antara 80% hingga 100%, sistem menetapkan status evaluasi kategori sebagai "Mendekati Batas".
   - Jika rasio pengeluaran > 100%, sistem menetapkan status evaluasi kategori sebagai "Melebihi Batas".
5. Backend mengembalikan struktur data berisi nominal alokasi, nominal terpakai, sisa dana, persentase utilisasi, dan label status kesehatan anggaran.
6. Frontend merender kartu anggaran dengan status visual yang sesuai; kartu berstatus "Melebihi Batas" menampilkan indikator pembengkakan (*overspending*) secara eksplisit.

## 7.4 Pencatatan Kontribusi Target Tabungan dan Pembaruan Progres Otomatis

1. Pengguna membuka modul "Target Tabungan", memilih salah satu kartu target tabungan aktif, lalu menekan tombol "Tambah Tabungan".
2. Pengguna memasukkan nominal setoran tabungan (misal: Rp500.000), tanggal setoran, dan catatan opsional pada modal dialog kontribusi.
3. Frontend mengeksekusi fungsi tersimpan (*stored procedure / RPC*) `record_savings_contribution` dengan parameter `goal_id`, `amount`, `contribution_date`, dan `notes`.
4. Sistem membuka transaksi atomik basis data (*atomic database transaction*):
   - Memvalidasi bahwa data target tabungan bersangkutan dimiliki oleh pengguna yang sedang aktif (`auth.uid() = user_id`).
   - Menyisipkan rekaman baru ke tabel `savings_contributions`.
   - Mengalkulasi penambahan nilai pada kolom `current_amount` pada baris tabel `savings_goals` terkait (`current_amount = current_amount + amount`).
   - Memeriksa apakah `current_amount >= target_amount`. Jika ya, sistem memperbarui nilai kolom `status` target tabungan menjadi "Tercapai" (*Completed*); jika belum, status tetap "Dalam Progres" (*In Progress*).
5. Transaksi basis data dinyatakan tuntas (*commit*), dan sistem mengembalikan status respon "Kontribusi Berhasil".
6. Frontend memperbarui tampilan bilah kemajuan (*progress bar*), akumulasi dana simpanan terkini, sisa dana yang dibutuhkan, dan status capaian target secara akurat.
7. *Pengecualian*: Jika nominal setoran bernilai `<= 0` atau target tabungan tidak ditemukan/bukan milik pengguna, transaksi dibatalkan (*rollback*) dengan status "Gagal Mencatat Kontribusi".

## 7.5 Penghapusan Transaksi dengan Rekalkulasi Finansial

1. Pengguna memilih satu baris transaksi pada modul "Manajemen Transaksi" dan menekan tombol hapus.
2. Frontend menampilkan dialog konfirmasi penghapusan (status antarmuka "Menunggu Konfirmasi").
3. Pengguna mengonfirmasi tindakan dengan menekan "Ya, Hapus".
4. Frontend mengirimkan perintah `DELETE` ke tabel `transactions` dengan menyertakan `id` transaksi.
5. Kebijakan RLS memverifikasi kecocokan `user_id = auth.uid()` pada baris yang dituju.
6. Baris transaksi dihapus secara permanen dari basis data fisik dengan status hasil "Berhasil Dihapus".
7. Kueri pembacaan berikutnya dari antarmuka akan langsung merefleksikan saldo total yang telah disesuaikan dan nilai realisasi pengeluaran pada modul anggaran kategori terkait secara deterministik.
8. *Pengecualian*: Jika pengguna mencoba mengeksekusi penghapusan terhadap transaksi milik pengguna lain, sistem RLS menolak aksi secara diam-diam (*zero rows affected*) atau mengembalikan galat izin akses ditolak (*insufficient privileges*).

# 8. Model Data (High-Level)

| **Entitas** | **Field Utama** | **Keterangan** |
| --- | --- | --- |
| **UserProfile** | id, user_id, full_name, email, avatar_url, currency_code, theme_preference, created_at, updated_at, [backup_frequency], [security_pin] | Menyimpan informasi profil personal, preferensi lokalisasi, dan preferensi antarmuka pengguna yang terhubung 1:1 ke entitas `auth.users`. |
| **Category** | id, name, type, icon_name, color_code, is_system_default, created_at, [user_id], [is_custom] | Klasifikasi pos transaksi untuk pengelompokan pengeluaran dan sumber pemasukan sistem. |
| **Transaction** | id, user_id, category_id, type, amount, transaction_date, description, payment_method, notes, created_at, updated_at, [receipt_attachment_url] | Mencatat seluruh catatan mutasi keuangan pengguna secara terperinci dengan presisi moneter eksak. |
| **Budget** | id, user_id, category_id, period_month, period_year, monthly_limit, created_at, updated_at, [notify_threshold] | Menyimpan batasan plafon pengeluaran bulanan yang dialokasikan pengguna untuk kategori tertentu pada periode spesifik. |
| **SavingsGoal** | id, user_id, goal_name, target_amount, current_amount, target_date, status, created_at, updated_at, [linked_account_id] | Menyimpan data target sasaran tabungan, nominal target yang direncanakan, dan akumulasi dana yang terkumpul. |
| **SavingsContribution** | id, user_id, goal_id, amount, contribution_date, notes, created_at, [source_account] | Mencatat setiap riwayat setoran kontribusi dana yang dialokasikan ke dalam target tabungan tertentu. |

**Catatan:** field dalam [tanda kurung siku] merupakan bagian dari fitur usulan/Fase Lanjutan (Bab 11).

# 9. Kebutuhan Non-Fungsional (Non-Functional Requirements)

- **Keamanan & Isolasi Data (Row Level Security) :** Seluruh tabel data yang menyimpan catatan pengguna wajib mengaktifkan Row Level Security (RLS) dengan kebijakan validasi kepemilikan data (`auth.uid() = user_id`) guna memastikan isolasi total sehingga pengguna tidak dapat membaca, mengubah, maupun menghapus rekaman milik pengguna lain.
- **Integritas Finansial & Presisi Moneter :** Nilai moneter pada transaksi, anggaran, dan tabungan wajib disimpan menggunakan tipe data numerik eksak PostgreSQL (`numeric` / `decimal`) tanpa toleransi terhadap penggunaan tipe floating-point, serta didukung oleh transaksi basis data atomik untuk mencegah anomali inkonsistensi saldo.
- **Perlindungan Kunci Akses (Credential Security) :** Klien antarmuka hanya diizinkan menggunakan kunci publik (`anon/public key`) dengan perlindungan hak akses RLS, dan dilarang keras mengekspos kunci administratif (`service-role key`) di dalam bundel kode peramban demi mencegah penyalahgunaan hak akses basis data.
- **Performa & Optimalisasi Kueri :** Basis data wajib dilengkapi indeks terstruktur pada kolom relasi foreign key, kolom filter waktu transaksi, serta kombinasi pencarian pengguna guna mempertahankan waktu tanggap eksekusi kueri di bawah 200 milidetik pada beban operasi normal.
- **Ketahanan & Validasi Masukan (Data Validation) :** Penegakan kendala integritas wajib diterapkan berlapis di level PostgreSQL (*check constraints* dan *foreign key constraints*) untuk menjamin bahwa data anomali (seperti nominal bertanda minus atau referensi kategori fiktif) ditolak secara konsisten di tingkat mesin basis data.
- **Konsistensi Zona Waktu Finansial :** Penyimpanan cap waktu sistem menggunakan format standar UTC (ISO-8601), dengan aturan pemotongan rentang agregasi siklus anggaran bulanan yang diselaraskan secara deterministik ke zona waktu operasional lokal pengguna (WIB / UTC+7).

# 10. Integrasi Pihak Ketiga

| **Layanan** | **Fungsi** | **Catatan** |
| --- | --- | --- |
| **Supabase Authentication** | Mengelola alur pendaftaran akun, validasi kata sandi, penerbitan token sesi JWT, penghentian sesi (*logout*), dan pemulihan akun via email. | Komponen Inti MVP (Backend). |
| **Supabase PostgREST & Database Client** | Menyediakan antarmuka komunikasi data kueri otomatis dari klien antarmuka langsung ke basis data PostgreSQL dengan penegakan RLS. | Komponen Inti MVP (Backend). |
| **PostgreSQL Database Engine** | Menyimpan seluruh data relasional, menegakkan kendala integritas moneter, mengeksekusi trigger pembuatan profil, serta menjalankan fungsi RPC agregasi data. | Komponen Inti MVP (Backend). |
| **Supabase Storage** | Menyediakan penyimpanan berkas awan (*bucket storage*) untuk berkas fisik lampiran bukti nota atau kuitansi transaksi. | Fase Lanjutan (Luar Lingkup MVP / Belum Diaktifkan). |
| **Layanan Open Finance / Bank Aggregator** | Menghubungkan mutasi rekening bank dan dompet digital pengguna secara otomatis ke dalam riwayat transaksi sistem. | Fase Lanjutan (Luar Lingkup MVP / Belum Diintegrasikan). |
| **Layanan Notifikasi Eksternal (Push/Email Engine)** | Mengirimkan pesan peringatan dini ke perangkat pengguna saat pengeluaran kategori mendekati atau melampaui alokasi batas bujet. | Fase Lanjutan (Luar Lingkup MVP / Belum Diintegrasikan). |

# 11. Fitur Usulan / Fase Lanjutan

- **Kustomisasi Kategori Transaksi Mandiri (Custom Categories).** Memberikan hak akses bagi pengguna untuk membuat, memperbarui, dan menghapus kategori transaksi personal tambahan yang dilengkapi metadata ikon dan warna kustom di luar kategori bawaan sistem.
- **Unggah Berkas Bukti Transaksi (Supabase Storage Integration).** Mengaktifkan ember penyimpanan (*storage bucket*) Supabase Storage agar pengguna dapat melampirkan berkas foto struk belanja atau dokumen bukti bayar langsung pada rekaman transaksi keuangan.
- **Sinkronisasi Otomatis Rekening Finansial (Open Finance).** Mengintegrasikan agregator perbankan pihak ketiga untuk menarik data mutasi transaksi pemasukan dan pengeluaran secara real-time tanpa keharusan input manual oleh pengguna.
- **Sistem Peringatan Ambang Batas Otomatis (Smart Budget Alerts).** Mengirimkan pemberitahuan otomatis berbasis push notification atau email ketika realisasi pengeluaran suatu kategori telah mencapai ambang batas kritis (misalnya 80% atau 100% dari plafon anggaran).
- **Ekspor dan Pencadangan Laporan Finansial.** Menyediakan fungsi pengunduhan rekapitulasi data arus kas, mutasi transaksi, dan laporan pencapaian tabungan dalam format dokumen portabel (CSV, XLSX, atau PDF).
- **Otentikasi Lanjutan & Proteksi Keamanan Akun.** Mengembangkan fitur Multi-Factor Authentication (MFA), login akun sosial (OAuth Google/GitHub), serta pengamanan verifikasi aksi penting menggunakan kode PIN atau biometrik perangkat.

# 12. Pertanyaan Terbuka / TBD

- Berapa batas kuota paginasi bawaan (*default page size*) yang disepakati untuk pembacaan riwayat transaksi per permintaan kueri klien (apakah 10, 20, atau 50 baris per halaman)?
- Apa saja daftar pasti kategori transaksi bawaan sistem (*default preset categories*) beserta penetapan format string ikon dan kode heksadesimal warnanya yang harus disertakan pada skema penyemaian data (*database seed*)?
- Apakah alur registrasi pengguna pada Supabase Auth langsung mengizinkan login aktif tanpa verifikasi email, atau wajib melakukan aktivasi akun via tautan email konfirmasi terlebih dahulu selama masa pengujian MVP?
- Apakah penghapusan data target tabungan yang masih memiliki saldo simpanan riil memerlukan konfirmasi pemindahan dana ke saldo utama, atau riwayat kontribusi langsung dihapus secara berjenjang (*cascading delete*)?
- Apakah siklus penetapan periode anggaran bulanan terkunci murni pada tanggal 1 hingga akhir bulan kalender, atau perlu mengakomodasi tanggal awal siklus gajian kustom pengguna di masa mendatang?

# 13. Glosarium

- **Row Level Security (RLS) :** Fitur keamanan tingkat mesin PostgreSQL yang membatasi hak akses pembacaan dan manipulasi baris data secara spesifik berdasarkan identitas pengguna (`auth.uid()`) yang tertera pada token sesi.
- **Remote Procedure Call (RPC) :** Prosedur atau fungsi tersimpan (*stored function*) di dalam PostgreSQL yang dapat dieksekusi secara langsung melalui Supabase Client SDK untuk menjalankan kalkulasi kompleks atau transaksi data atomik.
- **JSON Web Token (JWT) :** Token standar terbuka terenkripsi yang diterbitkan oleh Supabase Auth untuk memverifikasi identitas pengguna dan menegakkan kebijakan otorisasi pada setiap permintaan basis data.
- **Check Constraint :** Aturan validasi integritas data pada PostgreSQL yang memastikan bahwa nilai dalam suatu kolom memenuhi kriteria logis tertentu sebelum operasi penyimpanan diizinkan (contoh: nilai nominal wajib > 0).
- **Atomic Transaction :** Rangkaian operasi basis data yang dieksekusi sebagai satu kesatuan utuh yang tidak dapat terbagi, di mana seluruh operasi wajib berhasil secara bersamaan atau dibatalkan seutuhnya (*rollback*) jika terjadi kegagalan.
- **PostgREST :** Modul web server terintegrasi pada Supabase yang secara otomatis menyediakan endpoint antarmuka API RESTful aman langsung dari definisi skema basis data PostgreSQL.
- **Service-Role Key :** Kunci akses privat Supabase tingkat administrator dengan hak penuh untuk melompati seluruh batasan Row Level Security, yang hanya boleh digunakan di lingkungan backend server terisolasi.
- **Overspending :** Kondisi keuangan di mana akumulasi nilai transaksi pengeluaran aktual pada kategori tertentu melampaui batas plafon anggaran yang telah ditetapkan untuk periode tersebut.

---

*Dokumen ini merupakan draft sementara dan dapat berubah seiring pembahasan lebih lanjut dengan klien.*