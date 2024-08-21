import 'package:application/data/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expenseLogic = ChangeNotifierProvider((ref) => ExpenseLogic());

class ExpenseLogic extends ChangeNotifier {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  Category? _category;
  DateTime _date = DateTime.now();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _description = TextEditingController();

  GlobalKey<FormState> get key => _key;
  Category? get category => _category;
  DateTime get date => _date;
  TextEditingController get amount => _amount;
  TextEditingController get description => _description;

  set setCategory(Category? category) {
    _category = category;
    notifyListeners();
  }

  set setDate(DateTime? date) {
    if (date == null) return;
    _date = date;
    notifyListeners();
  }
}
