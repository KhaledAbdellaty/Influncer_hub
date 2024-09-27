
extension Currency on String {
  String currencyName() {
    switch (this) {
      case 'LE':
        return 'EGP';
      case '\$':
        return 'USD';
      case '€':
        return 'EUR';
      case '£':
        return 'GBP';
      case 'Pts':
        return 'ESP';
    }
    return this;
  }
}
