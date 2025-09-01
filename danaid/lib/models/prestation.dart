class Prestation {
  final String id;
  final String title;
  final String hospital;
  final String? reference;
  final String status;
  final DateTime? date;
  final double? amount;
  final double? coverageRate;
  final bool isActive;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Prestation({
    required this.id,
    required this.title,
    required this.hospital,
    this.reference,
    required this.status,
    this.date,
    this.amount,
    this.coverageRate,
    this.isActive = true,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Prestation.fromMap(Map<String, dynamic> map, String id) {
    return Prestation(
      id: id,
      title: map['title'] ?? '',
      hospital: map['hospital'] ?? '',
      reference: map['reference'],
      status: map['status'] ?? 'En cours',
      date: map['date']?.toDate(),
      amount: map['amount']?.toDouble(),
      coverageRate: map['coverageRate']?.toDouble() ?? 70.0,
      isActive: map['isActive'] ?? true,
      userId: map['userId'],
      createdAt: map['createdAt']?.toDate(),
      updatedAt: map['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'hospital': hospital,
      'reference': reference,
      'status': status,
      'date': date,
      'amount': amount,
      'coverageRate': coverageRate,
      'isActive': isActive,
      'userId': userId,
      'createdAt': createdAt,
      'updatedAt': DateTime.now(),
    };
  }
}
