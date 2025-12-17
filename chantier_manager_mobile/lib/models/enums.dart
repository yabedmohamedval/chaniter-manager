enum RoleUtilisateur {
  RESPONSABLE_CHANTIERS,
  CHEF_CHANTIER,
  EQUIPIER,
}

enum StatutChantier {
  NON_REALISE,
  EN_COURS,
  INTERROMPU,
  TERMINE,
}

extension EnumParsing on String {
  T? toEnumOrNull<T>(List<T> values) {
    try {
      // ignore: avoid_dynamic_calls
      return values.firstWhere(
            (v) => (v as dynamic).name == this,
      );
    } catch (_) {
      return null;
    }
  }
}
