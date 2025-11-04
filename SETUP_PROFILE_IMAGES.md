# Setup Profile Images - Instruksi

## Struktur Folder yang Diperlukan

Buat folder untuk menyimpan gambar profil dengan struktur berikut:

```
w3dating_app/
├── assets/
│   └── images/
│       └── profiles/
│           ├── sarah.jpg
│           ├── emma.jpg
│           ├── olivia.jpg
│           ├── sophia.jpg
│           └── isabella.jpg
```

## Langkah-langkah Setup

### 1. Buat Folder Assets

Buat folder `assets/images/profiles/` di root project Anda jika belum ada.

### 2. Siapkan Gambar

Siapkan 5 gambar profil dengan nama sesuai template:
- `sarah.jpg` - Untuk profil Sarah (24 tahun, Photographer)
- `emma.jpg` - Untuk profil Emma (26 tahun, Nutritionist)
- `olivia.jpg` - Untuk profil Olivia (23 tahun, Graphic Designer)
- `sophia.jpg` - Untuk profil Sophia (27 tahun, Marketing Manager)
- `isabella.jpg` - Untuk profil Isabella (25 tahun, Software Engineer)

**Rekomendasi Format Gambar:**
- Format: JPG atau PNG
- Ukuran: Minimal 800x1000 pixels (portrait orientation)
- Resolusi: 72-150 dpi
- Ukuran file: < 2MB per gambar

### 3. Update pubspec.yaml

Tambahkan assets di file `pubspec.yaml`:

```yaml
flutter:
  uses-material-design: true
  
  assets:
    - assets/images/profiles/
    # Atau spesifik per file:
    # - assets/images/profiles/sarah.jpg
    # - assets/images/profiles/emma.jpg
    # - assets/images/profiles/olivia.jpg
    # - assets/images/profiles/sophia.jpg
    # - assets/images/profiles/isabella.jpg
```

### 4. Run Flutter Command

Setelah menambahkan assets, jalankan:

```bash
flutter pub get
```

## Template Data Profil

Lokasi file: `lib/home/home_screen.dart` (baris 14-68)

```dart
final List<Map<String, dynamic>> _profiles = [
  {
    'name': 'Sarah',              // Nama
    'age': '24',                  // Umur
    'location': 'Jakarta',        // Lokasi/Kota
    'distance': '2 km',          // Jarak
    'image': 'assets/images/profiles/sarah.jpg',  // Path gambar
    'bio': 'Love traveling and photography',      // Bio singkat
    'interests': ['Photography', 'Travel', 'Coffee'],  // Hobi (max 3-4)
    'occupation': 'Photographer', // Pekerjaan
    'isNew': true,               // true = tampilkan badge "New here"
  },
  // ... profil lainnya
];
```

## Cara Mengedit Data Profil

### Menambah Profil Baru

Tambahkan object baru di array `_profiles`:

```dart
{
  'name': 'Jennifer',
  'age': '28',
  'location': 'Medan',
  'distance': '6 km',
  'image': 'assets/images/profiles/jennifer.jpg',
  'bio': 'Fashion designer and cat lover',
  'interests': ['Fashion', 'Cats', 'Shopping'],
  'occupation': 'Fashion Designer',
  'isNew': false,
},
```

### Mengganti Gambar

Cukup ganti file gambar di folder `assets/images/profiles/` dengan nama yang sama, atau update path di field `'image'`.

### Mengedit Informasi

Edit langsung value di setiap field:
- `name` - Nama profil
- `age` - Umur (string)
- `location` - Kota/lokasi
- `distance` - Jarak (dengan satuan)
- `image` - Path ke gambar lokal
- `bio` - Deskripsi singkat (opsional, tidak ditampilkan di home)
- `interests` - Array hobi/minat (ditampilkan sebagai chips)
- `occupation` - Pekerjaan (opsional, tidak ditampilkan di home)
- `isNew` - `true` untuk menampilkan badge "New here", `false` untuk menyembunyikan

## Troubleshooting

### Gambar Tidak Muncul

1. ✅ Pastikan path di `pubspec.yaml` sudah benar
2. ✅ Jalankan `flutter pub get`
3. ✅ Restart aplikasi (Hot reload mungkin tidak cukup untuk assets baru)
4. ✅ Cek nama file gambar sesuai dengan yang di code (case sensitive)
5. ✅ Pastikan gambar ada di folder yang benar

### Error "Unable to load asset"

- Periksa kembali path di `pubspec.yaml`
- Pastikan indentasi YAML benar (gunakan spaces, bukan tabs)
- Path harus relative dari root project

### Gambar Terlalu Besar/Lambat

- Kompres gambar menggunakan tools seperti TinyPNG atau ImageOptim
- Gunakan format JPG untuk file size lebih kecil
- Ukuran ideal: 800x1000 pixels, < 500KB per file

## Tips

- Gunakan gambar portrait (vertikal) untuk hasil terbaik
- Gambar dengan ratio 4:5 atau 3:4 akan terlihat bagus
- Pastikan wajah terlihat jelas di bagian atas gambar
- Hindari gambar yang terlalu gelap di bagian bawah (karena ada gradient overlay)

## Contoh Sumber Gambar Gratis

Jika butuh placeholder images:
- Unsplash: https://unsplash.com/
- Pexels: https://pexels.com/
- Pixabay: https://pixabay.com/

**Note:** Pastikan Anda memiliki hak untuk menggunakan gambar yang dipilih.
