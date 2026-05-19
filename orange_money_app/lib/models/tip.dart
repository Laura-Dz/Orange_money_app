class Tip {
  final int? id;
  final String title;
  final String description;
  final String image;

  Tip({
    this.id,
    required this.title,
    required this.description,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'description': description,
      'image': image,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Tip.fromMap(Map<String, dynamic> map) {
    return Tip(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
    );
  }
}
