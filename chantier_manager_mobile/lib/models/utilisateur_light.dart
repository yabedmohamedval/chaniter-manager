class UtilisateurLight {
  final int id;
  final String nom;
  final String prenom;
  final String role;

  UtilisateurLight({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.role,
  });

  factory UtilisateurLight.fromJson(Map<String, dynamic> json) {
    return UtilisateurLight(
      id: json['id'],
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      role: json['role'] ?? '',
    );
  }

  String get fullName => "$prenom $nom".trim();
}
