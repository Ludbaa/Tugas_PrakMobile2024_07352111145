import 'package:intl/intl.dart';

String formatToRupiah(dynamic number) {
  return NumberFormat.currency(
    locale: 'id_ID', // Locale Indonesia
    symbol: 'Rp',    // Simbol mata uang
    decimalDigits: 0, // Tidak ada desimal
  ).format(number);
}