class Validators {
  /// Vérifie si la chaîne contient exactement 4 chiffres
  static bool isValidChassis(String value) {
    // L'expression régulière ^\d{4}$ signifie :
    // ^ : début de la chaîne
    // \d : uniquement des chiffres (0-9)
    // {4} : exactement 4 fois
    // $ : fin de la chaîne
    final RegExp regex = RegExp(r'^\d{4}$');
    return regex.hasMatch(value);
  }
}
