class CurrencyUtils {
  static const Map<String, String> currencySymbols = {
    'USD': r'$',
    'EUR': '€',
    'GBP': '£',
    'KES': 'KSh',
    'TZS': 'TSh',
  };

  static String getCurrencySymbol(String currencyCode) {
    return currencySymbols[currencyCode] ?? currencyCode;
  }

  static String formatAmount(double amount, String currencyCode) {
    final symbol = getCurrencySymbol(currencyCode);
    return '$symbol${amount.toStringAsFixed(2)}';
  }
}
