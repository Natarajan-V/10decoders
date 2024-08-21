import 'dart:convert';
import 'dart:developer';
import 'package:application/models/expense.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final hiveProvider = ChangeNotifierProvider((ref) => HiveProvider());

class HiveProvider extends ChangeNotifier {
  static const String _collection = 'Collection';

  Box<String>? _expense;

  Box<String>? get expense => _expense;

  Future<void> openHive() async {
    try {
      _expense = await Hive.openBox<String>(_collection);
      notifyListeners();
    } catch (e) {
      log(e.toString());
      return;
    }
  }

  List<ExpenseModel> get fetchExpense {
    try {
      final list = _expense?.values ?? [];

      return list.map((e) {
        final json = jsonDecode(e);
        return ExpenseModel.fromJson(json);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  String get getTotalExpense {
    try {
      final list = _expense?.values ?? [];
      final expense = list.map((e) {
        final json = jsonDecode(e);
        return ExpenseModel.fromJson(json);
      }).toList();

      final totalExpense = expense.reduce((a, b) {
        return ExpenseModel(amount: (a.amount ?? 0) + (b.amount ?? 0));
      });

      return (totalExpense.amount ?? 0).toStringAsFixed(2);
    } catch (e) {
      return '0';
    }
  }

  Future<void> addExpense(ExpenseModel data) async {
    try {
      if (expense == null) return;

      final json = jsonEncode(data.toJson());
      await _expense?.add(json);
      notifyListeners();
    } catch (e) {
      log(e.toString());
      return;
    }
  }
}
