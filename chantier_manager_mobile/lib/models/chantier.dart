import 'dart:convert';
import 'enums.dart';
import 'utilisateur.dart';

// chantier.dart
class Chantier {
  final int? id;
  final String objet;
  final String? lieu;
  final DateTime? dateDebut;
  final int? nbDemiJournees;
  final String? contactClientNom;
  final String? contactClientTelephone;
  final StatutChantier? statut;
  // liens vers d'autres entités
  final int? chefId;
  final Utilisateur? chef;
  final int? equipeId;

  Chantier({
    this.id,
    required this.objet,
    this.lieu,
    this.dateDebut,
    this.nbDemiJournees,
    this.contactClientNom,
    this.contactClientTelephone,
    this.statut,
    this.chefId,
    this.chef,
    this.equipeId,
  });

  factory Chantier.fromJson(Map<String, dynamic> json) {
    final chefJson = json['chef'] as Map<String, dynamic>?;
    return Chantier(
      id: json['id'] as int?,
      objet: json['objet'] as String? ?? '',
      lieu: json['lieu'] as String?,
      dateDebut: json['dateDebut'] != null
          ? DateTime.parse(json['dateDebut'] as String)
          : null,
      nbDemiJournees: json['nbDemiJournees'] as int?,
      contactClientNom: json['contactClientNom'] as String?,
      contactClientTelephone: json['contactClientTelephone'] as String?,
      statut: json['statut'] != null
          ? StatutChantier.values.byName(json['statut'] as String)
          : null,
      chefId: json['chefId'] as int? ??
          (chefJson != null ? chefJson['id'] as int? : null),
      chef: chefJson != null ? Utilisateur.fromJson(chefJson) : null,
      equipeId: json['equipeId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'objet': objet,
      'lieu': lieu,
      'dateDebut': dateDebut?.toIso8601String(),
      'nbDemiJournees': nbDemiJournees,
      'contactClientNom': contactClientNom,
      'contactClientTelephone': contactClientTelephone,
      'statut': statut?.name,
      'chefId': chefId ?? chef?.id,
      // on n’envoie pas forcément tout l’objet chef pour les POST/PUT
      'equipeId': equipeId,
    };
  }
}
