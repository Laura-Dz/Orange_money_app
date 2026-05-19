class Transaction {
  final int? id;
  final int userId;
  final String merchant;
  final String type;
  final double amount;
  final String date;

  Transaction({
    this.id,
    required this.userId,
    required this.merchant,
    required this.type,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'userId': userId,
      'merchant': merchant,
      'type': type,
      'amount': amount,
      'date': date,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as int?,
      userId: map['userId'] as int,
      merchant: map['merchant'] as String,
      type: map['type'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: map['date'] as String,
    );
  }
}
