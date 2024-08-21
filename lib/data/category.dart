enum Category {
  food(id: 1, value: 'Food'),
  travel(id: 2, value: 'Travel'),
  entertainment(id: 3, value: 'Entertainment'),
  saving(id: 4, value: 'Savings'),
  shopping(id: 5, value: 'Shopping');

  final int id;
  final String value;

  const Category({required this.id, required this.value});

  static List<Category> _category = [
    food,
    travel,
    entertainment,
    saving,
    shopping
  ];

  static List<Category> get category => _category;

  static String parse(int? id) {
    if (id == null) return '';
    return _category.firstWhere((e) => e.id == id).value;
  }
}
