class PhotoChantier {
  final int id;
  final String url;
  final DateTime? datePrise;
  final String? commentaire;
  final int? chantierId;
  final int? anomalieId;

  const PhotoChantier({
    required this.id,
    required this.url,
    this.datePrise,
    this.commentaire,
    this.chantierId,
    this.anomalieId,
  });

  factory PhotoChantier.fromJson(Map<String, dynamic> json) {
    return PhotoChantier(
      id: json['id'] as int,
      url: json['url'] as String? ?? '',
      datePrise: json['datePrise'] != null
          ? DateTime.tryParse(json['datePrise'] as String)
          : null,
      commentaire: json['commentaire'] as String?,
      chantierId: json['chantierId'] as int?,
      anomalieId: json['anomalieId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'datePrise': datePrise?.toIso8601String(),
      'commentaire': commentaire,
      'chantierId': chantierId,
      'anomalieId': anomalieId,
    };
  }
}
