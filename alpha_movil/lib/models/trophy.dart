class Trophy {
  final int id;
  final String? code;
  final String title;
  final String description;
  final DateTime? awardedAt;

  Trophy({
    required this.id,
    this.code,
    required this.title,
    required this.description,
    this.awardedAt,
  });

  factory Trophy.fromJson(Map<String, dynamic> json) {
    return Trophy(
      id: json['id'] as int,
      code: json['code'] as String?, // El API no devuelve code en la consulta de trophies
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      awardedAt: json['awarded_at'] != null
          ? DateTime.parse(json['awarded_at'] as String)
          : json['awardedAt'] != null
              ? DateTime.parse(json['awardedAt'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'description': description,
      'awardedAt': awardedAt?.toIso8601String(),
    };
  }
}

