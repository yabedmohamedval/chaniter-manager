import 'utilisateur_light.dart';

class Equipe {
  final int id;
  final String nom;
  final UtilisateurLight? chef;
  final List<UtilisateurLight> membres;

  Equipe({
    required this.id,
    required this.nom,
    required this.chef,
    required this.membres,
  });

  factory Equipe.fromJson(Map<String, dynamic> json) {
    return Equipe(
      id: json['id'],
      nom: json['nom'] ?? '',
      chef: json['chef'] == null ? null : UtilisateurLight.fromJson(json['chef']),
      membres: (json['membres'] as List? ?? [])
          .map((e) => UtilisateurLight.fromJson(e))
          .toList(),
    );
  }
}
