import 'dart:collection';

// Enum untuk kategori produk
enum Kategori { DataManagement, NetworkAutomation }

// Enum untuk fase proyek
enum FaseProyek { Perencanaan, Pengembangan, Evaluasi }

// Kelas untuk produk digital
class Produk {
  String namaProduk;
  double harga;
  Kategori kategori;
  int terjual;

  Produk(this.namaProduk, this.harga, this.kategori, {this.terjual = 0}) {
    _validasiHarga();
  }

  void _validasiHarga() {
    if (kategori == Kategori.NetworkAutomation && harga < 200000) {
      throw Exception(
          'Harga untuk produk NetworkAutomation harus minimal 200.000.');
    }
    if (kategori == Kategori.DataManagement && harga >= 200000) {
      throw Exception(
          'Harga untuk produk DataManagement harus di bawah 200.000.');
    }
  }

  double hargaAkhir() {
    double finalPrice = harga;

    if (kategori == Kategori.NetworkAutomation && terjual > 50) {
      double discount = harga * 0.15;
      finalPrice = harga - discount;
      if (finalPrice < 200000) {
        return 200000; // Tidak boleh di bawah 200.000
      }
    }
    return finalPrice;
  }
}

// Mixin untuk evaluasi kinerja
mixin Kinerja {
  int produktivitas = 0;

  void updateProduktivitas(int nilai) {
    if (nilai < 0 || nilai > 100) {
      throw Exception('Nilai produktivitas harus antara 0 dan 100.');
    }
    produktivitas = nilai;
  }
}

// Kelas untuk karyawan
abstract class Karyawan {
  String nama;
  int umur;
  String peran;

  Karyawan(this.nama, {required this.umur, required this.peran});
}

// Kelas untuk karyawan tetap
class KaryawanTetap extends Karyawan with Kinerja {
  KaryawanTetap(String nama, {required int umur})
      : super(nama, umur: umur, peran: 'Tetap');

  @override
  void updateProduktivitas(int nilai) {
    if (peran == 'Manager' && nilai < 85) {
      throw Exception('Manager harus memiliki produktivitas minimal 85.');
    }
    super.updateProduktivitas(nilai);
  }
}

// Kelas untuk karyawan kontrak
class KaryawanKontrak extends Karyawan with Kinerja {
  KaryawanKontrak(String nama, {required int umur})
      : super(nama, umur: umur, peran: 'Kontrak');
}

// Kelas untuk manajemen proyek
class Proyek {
  String namaProyek;
  FaseProyek fase;
  List<Karyawan> karyawanAktif;

  Proyek(this.namaProyek)
      : fase = FaseProyek.Perencanaan,
        karyawanAktif = [];

  void tambahKaryawan(Karyawan karyawan) {
    if (karyawanAktif.length >= 20) {
      throw Exception('Maksimal 20 karyawan aktif dalam satu waktu.');
    }
    karyawanAktif.add(karyawan);
  }

  void pindahFase() {
    switch (fase) {
      case FaseProyek.Perencanaan:
        if (karyawanAktif.length >= 5) {
          fase = FaseProyek.Pengembangan;
        } else {
          throw Exception(
              'Minimal 5 karyawan aktif diperlukan untuk pindah ke fase Pengembangan.');
        }
        break;
      case FaseProyek.Pengembangan:
        // Simulasi pengecekan durasi proyek
        if (true /* Gantikan dengan logika durasi proyek */) {
          fase = FaseProyek.Evaluasi;
        } else {
          throw Exception(
              'Proyek harus berjalan lebih dari 45 hari untuk pindah ke fase Evaluasi.');
        }
        break;
      case FaseProyek.Evaluasi:
        // Tidak ada fase selanjutnya
        break;
    }
  }
}

void main() {
  // Contoh penggunaan
  try {
    // Membuat produk
    Produk produk1 =
        Produk('Sistem Manajemen Data', 150000, Kategori.DataManagement);
    Produk produk2 = Produk(
        'Sistem Otomasi Jaringan', 250000, Kategori.NetworkAutomation,
        terjual: 60);

    print('Harga akhir produk 1: ${produk1.hargaAkhir()}');
    print('Harga akhir produk 2: ${produk2.hargaAkhir()}');

    // Membuat karyawan
    KaryawanTetap karyawan1 = KaryawanTetap('Alice', umur: 30);
    KaryawanTetap karyawan2 = KaryawanTetap('Bob', umur: 40);
    KaryawanKontrak karyawan3 = KaryawanKontrak('Charlie', umur: 25);

    // Mengupdate produktivitas
    karyawan1.updateProduktivitas(90);
    karyawan2.updateProduktivitas(80);
    karyawan3.updateProduktivitas(70);

    print('${karyawan1.nama} - Produktivitas: ${karyawan1.produktivitas}');
    print('${karyawan2.nama} - Produktivitas: ${karyawan2.produktivitas}');
    print('${karyawan3.nama} - Produktivitas: ${karyawan3.produktivitas}');

    // Membuat proyek
    Proyek proyek = Proyek('Proyek Pengembangan Software');

    // Menambah karyawan ke proyek
    proyek.tambahKaryawan(karyawan1);
    proyek.tambahKaryawan(karyawan2);
    proyek.tambahKaryawan(karyawan3);

    // Coba pindah fase proyek
    try {
      proyek.pindahFase(); // Pindah ke fase Pengembangan
      print('Fase proyek sekarang: ${proyek.fase}');
    } catch (e) {
      print('Kesalahan saat pindah fase: $e');
    }

    // Menambahkan lebih banyak karyawan untuk memenuhi syarat pindah fase
    KaryawanTetap karyawan4 = KaryawanTetap('David', umur: 35);
    KaryawanTetap karyawan5 = KaryawanTetap('Eva', umur: 28);
    KaryawanTetap karyawan6 = KaryawanTetap('Frank', umur: 32);
    KaryawanTetap karyawan7 = KaryawanTetap('Grace', umur: 29);

    proyek.tambahKaryawan(karyawan4);
    proyek.tambahKaryawan(karyawan5);
    proyek.tambahKaryawan(karyawan6);
    proyek.tambahKaryawan(karyawan7);

    // Coba pindah fase lagi
    try {
      proyek.pindahFase(); // Pindah ke fase Evaluasi
      print('Fase proyek sekarang: ${proyek.fase}');
    } catch (e) {
      print('Kesalahan saat pindah fase: $e');
    }

    // Menampilkan semua karyawan dalam proyek
    print('Karyawan dalam proyek:');
    for (var karyawan in proyek.karyawanAktif) {
      print('${karyawan.nama} - Peran: ${karyawan.peran}');
    }
  } catch (e) {
    print('Kesalahan: $e');
  }
}
