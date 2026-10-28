import 'package:intl/intl.dart';

class CurrencyFormatter {
  // Uses Indian Rupee (₹) with Indian numbering format (e.g. ₹1,50,000.00)
  static String format(double amount, {String symbol = '₹'}) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }
}
