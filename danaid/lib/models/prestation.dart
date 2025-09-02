class Prestation {
  String id;
  String title;
  String description;
  String establishment;
  String coverage;
  String status;
  String contact;
  String accessCode;
  double cost;
  String reason;
  int rate;

  Prestation({
    this.id = '',
    required this.title,
    required this.description,
    required this.establishment,
    required this.coverage,
    required this.status,
    required this.contact,
    required this.accessCode,
    required this.cost,
    required this.reason,
    required this.rate,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'establishment': establishment,
      'coverage': coverage,
      'status': status,
      'contact': contact,
      'accessCode': accessCode,
      'cost': cost,
      'reason': reason,
      'rate': rate,
    };
  }

  static Prestation fromMap(Map<String, dynamic> map, String id) {
    return Prestation(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      establishment: map['establishment'] ?? '',
      coverage: map['coverage'] ?? '',
      status: map['status'] ?? '',
      contact: map['contact'] ?? '',
      accessCode: map['accessCode'] ?? '',
      cost: map['cost']?.toDouble() ?? 0.0,
      reason: map['reason'] ?? '',
      rate: map['rate']?.toInt() ?? 0,
    );
  }
}