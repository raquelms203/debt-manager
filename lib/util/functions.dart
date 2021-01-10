import 'package:intl/intl.dart';

String dateFormatted(DateTime date) {
  String day = date.day.toString();
  String month = date.month.toString();
  if (day.length == 1) day = "0" + day;
  if (month.length == 1) month = "0" + month;
  String formatted = ("$day/$month/${date.year}");
  return formatted;
}

double currencyToNumber(String currency) {
  currency = currency.substring(3, currency.length);
  currency = currency.replaceAll(".", "");
  currency = currency.replaceAll(",", ".");
  return double.parse(currency);
}

String numberToCurrency(double number) {
  NumberFormat formatter = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  return formatter.format(number);
}

double percentageToNumber(String percentage) {
  percentage = percentage.substring(0, percentage.length - 2);
  return double.parse(percentage);
}
