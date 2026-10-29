import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _lkrFormat = NumberFormat('#,##0.00', 'en_US');
  static final NumberFormat _lkrCompact = NumberFormat('#,##0', 'en_US');

  static String format(num amount) {
    return 'Rs. ${_lkrFormat.format(amount)}';
  }

  static String formatInt(num amount) {
    return 'Rs. ${_lkrCompact.format(amount)}';
  }
}
