import 'package:chantier_manager_mobile/models/photo_chantier.dart';
import 'package:chantier_manager_mobile/models/utilisateur.dart';

class Anomalie {
  final int id;
  final String description;
  final DateTime? creeLe;
  final String? photoPath;
  final List<PhotoChantier> photos;
  final Utilisateur? auteur;

  const Anomalie({
    required this.id,
    required this.description,
    this.creeLe,
    this.photoPath,
    this.auteur,
    this.photos = const [], // 👈 valeur par défaut
  });

  factory Anomalie.fromJson(Map<String, dynamic> json) {
    return Anomalie(
      id: json['id'] as int,
      description: json['description'] as String? ?? '',
      creeLe: json['creeLe'] != null
          ? DateTime.parse(json['creeLe'] as String)
          : null,
      photoPath: json['photoPath'] as String?,
      auteur: json['auteur'] != null && json['auteur'] is Map<String, dynamic>
          ? Utilisateur.fromJson(
        (json['auteur'] as Map).cast<String, dynamic>(),
      )
          : null,
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => PhotoChantier.fromJson(
        (e as Map).cast<String, dynamic>(),
      ))
          .toList() ??
          const [],
    );
  }
}
