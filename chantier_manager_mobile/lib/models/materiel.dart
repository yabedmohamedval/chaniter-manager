class Materiel {
  final int id;
  final String libelle;
  final String? type;
  final int quantiteTotale;

  const Materiel({
    required this.id,
    required this.libelle,
    this.type,
    required this.quantiteTotale,
  });

  factory Materiel.fromJson(Map<String, dynamic> json) {
    return Materiel(
      id: json['id'] as int,
      libelle: (json['libelle'] ?? '') as String,
      type: json['type'] as String?,
      quantiteTotale: (json['quantiteTotale'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "libelle": libelle,
    "type": type,
    "quantiteTotale": quantiteTotale,
  };
}
