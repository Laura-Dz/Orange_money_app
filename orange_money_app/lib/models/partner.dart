class Partner {
  final int? id;
  final String name;
  final String logo;

  Partner({
    this.id,
    required this.name,
    required this.logo,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'logo': logo,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Partner.fromMap(Map<String, dynamic> map) {
    return Partner(
      id: map['id'] as int?,
      name: map['name'] as String,
      logo: map['logo'] as String,
    );
  }
}
