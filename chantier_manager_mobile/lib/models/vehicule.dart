class Vehicule {
  final int id;
  final String? immatriculation;
  final String? type;
  final String? libelle;
  final bool disponible;

  const Vehicule({
    required this.id,
    this.immatriculation,
    this.type,
    this.libelle,
    required this.disponible,
  });

  factory Vehicule.fromJson(Map<String, dynamic> json) {
    return Vehicule(
      id: json['id'] as int,
      immatriculation: json['immatriculation'] as String?,
      type: json['type'] as String?,
      libelle: json['libelle'] as String?,
      disponible: (json['disponible'] ?? true) as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "immatriculation": immatriculation,
    "type": type,
    "libelle": libelle,
    "disponible": disponible,
  };
}
