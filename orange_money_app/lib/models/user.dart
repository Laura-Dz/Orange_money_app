class User {
  final int? id;
  final String name;
  final String phone;
  final double balance;

  User({
    this.id,
    required this.name,
    required this.phone,
    required this.balance,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'phone': phone,
      'balance': balance,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      name: map['name'] as String,
      phone: map['phone'] as String,
      balance: (map['balance'] as num).toDouble(),
    );
  }
}
