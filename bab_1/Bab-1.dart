import 'dart:async';
import 'dart:io'; // Import untuk menggunakan stdin

// Enum untuk Role
enum Role { Admin, Customer }

// Kelas Product
class Product {
  String productName;
  double price;
  bool inStock;

  Product(this.productName, this.price, this.inStock);
}

// Kelas User
class User {
  String name;
  int age;
  late List<Product>
      products; // Menggunakan late untuk inisialisasi setelah objek dibuat
  Role? role; // Nullable type untuk role

  User(this.name, this.age) {
    products = []; // Inisialisasi produk
  }

  void displayProducts() {
    if (products.isEmpty) {
      print('$name Tidak memiliki produk.');
    } else {
      print('$name\'s Products:');
      for (var product in products) {
        print(
            '- ${product.productName} (Harga: \$${product.price}, Isi Stock: ${product.inStock})');
      }
    }
  }
}

// Subclass AdminUser
class AdminUser extends User {
  AdminUser(String name, int age) : super(name, age) {
    role = Role.Admin; // Set role sebagai Admin
  }

  void addProduct(Product product) {
    if (product.inStock) {
      products.add(product);
      print('Product ${product.productName} ditambahkan oleh Admin $name.');
    } else {
      print(
          'Error: Product ${product.productName} diluar dari stok tidak bisa ditambahkan.');
    }
  }

  void removeProduct(String productName) {
    products.removeWhere((product) => product.productName == productName);
    print('Product $productName telah dihapus oleh Admin $name.');
  }
}

// Subclass CustomerUser
class CustomerUser extends User {
  CustomerUser(String name, int age) : super(name, age) {
    role = Role.Customer; // Set role sebagai Customer
  }
}

// Fungsi asinkron untuk mengambil detail produk
Future<Product> fetchProductDetails(String productName) async {
  // Simulasi pengambilan data dari server dengan delay
  await Future.delayed(Duration(seconds: 2));
  return Product(productName, 29.99, true);
}

void main() async {
  // Meminta input dari pengguna untuk memilih role
  print('Masukkan nama Anda:');
  String? name = stdin.readLineSync();

  print('Masukkan umur Anda:');
  String? ageInput = stdin.readLineSync();
  int age = int.tryParse(ageInput ?? '0') ?? 0; // Mengonversi input ke int

  print('Pilih role Anda (1: Admin, 2: Customer):');
  String? roleInput = stdin.readLineSync();
  Role role;

  if (roleInput == '1') {
    role = Role.Admin;
  } else {
    role = Role.Customer;
  }

  // Membuat objek User berdasarkan role yang dipilih
  User user;
  if (role == Role.Admin) {
    user = AdminUser(name ?? 'Admin', age);
  } else {
    user = CustomerUser(name ?? 'Customer', age);
  }

  // Contoh penggunaan
  if (user is AdminUser) {
    // Menambahkan produk
    try {
      Product newProduct1 = await fetchProductDetails('Laptop');
      Product newProduct2 = await fetchProductDetails('Handphone');
      Product newProduct3 = await fetchProductDetails('Headseat');
      user.addProduct(newProduct1);
      user.addProduct(newProduct2);
      user.addProduct(newProduct3);

      // Menambahkan produk yang tidak ada di stok
      Product outOfStockProduct = Product('Phone', 499.99, false);
      user.addProduct(outOfStockProduct);

      // Menampilkan produk
      user.displayProducts();
    } catch (e) {
      print('Terjadi error: $e');
    }
  } else if (user is CustomerUser) {
    // Customer melihat produk
    print('Customer ${user.name} Menampilkan Produk:');
    user.displayProducts();
  }
}
