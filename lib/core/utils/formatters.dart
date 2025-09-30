import 'package:intl/intl.dart';

class Formatters {
  static final _currency = NumberFormat.simpleCurrency(decimalDigits: 2);
  static String money(double value) => _currency.format(value);
}
