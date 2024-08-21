class ExpenseModel {
  int? id;
  int? category;
  String? description;
  double? amount;
  int? dateTime;
  int? createdAt;

  ExpenseModel({
    this.id,
    this.category,
    this.description,
    this.amount,
    this.dateTime,
    this.createdAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      category: json['category'],
      description: json['description'],
      amount: json['amount'],
      dateTime: json['dateTime'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    data['id'] = id;
    data['category'] = category;
    data['description'] = description;
    data['amount'] = amount;
    data['dateTime'] = dateTime;
    data['createdAt'] = createdAt;

    return data;
  }
}
