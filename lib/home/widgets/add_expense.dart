import 'dart:developer';

import 'package:application/data/category.dart';
import 'package:application/home/logic/logic.dart';
import 'package:application/models/expense.model.dart';
import 'package:application/providers/hive.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AddExpense extends ConsumerStatefulWidget {
  const AddExpense({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddExpenseState();
}

class _AddExpenseState extends ConsumerState<AddExpense> {
  @override
  void initState() {
    Future.microtask(() => ref.refresh(expenseLogic));
    super.initState();
  }

  Future<void> _addExpense() async {
    try {
      final provider = ref.read(expenseLogic);
      final hive = ref.read(hiveProvider);

      final isValid = provider.key.currentState?.validate() ?? false;

      if (!isValid) return;

      final int createdAt = DateTime.now().millisecondsSinceEpoch;

      final ExpenseModel expense = ExpenseModel(
        id: createdAt,
        category: provider.category?.id,
        amount: double.tryParse(provider.amount.text),
        description: provider.description.text,
        dateTime: provider.date.millisecondsSinceEpoch,
        createdAt: createdAt,
      );

      await hive.addExpense(expense);

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.read(expenseLogic);
    final logic = ref.watch(expenseLogic);

    DateTime date = logic.date;

    return SingleChildScrollView(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: provider.key,
          child: Column(children: [
            DropdownButtonFormField<Category>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Category',
              ),
              items: Category.category.map((e) {
                return DropdownMenuItem<Category>(
                  value: e,
                  child: Text(e.value),
                );
              }).toList(),
              validator: (value) {
                if (value == null) return 'Required';
                return null;
              },
              onChanged: (value) => provider.setCategory = value,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: provider.amount,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Amount',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                return null;
              },
            ),
            const SizedBox(height: 16),
            MaterialButton(
              height: 50,
              minWidth: double.infinity,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(color: Colors.black54),
              ),
              onPressed: () async {
                provider.setDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  initialDate: DateTime.now(),
                  lastDate: DateTime.now(),
                );
              },
              child: Row(children: [
                const Icon(Icons.calendar_month, color: Colors.black45),
                const SizedBox(width: 16),
                Text(DateFormat('dd MMM yyyy').format(date)),
              ]),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: provider.description,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Description',
              ),
              minLines: 1,
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            MaterialButton(
              minWidth: double.infinity,
              color: Colors.blueAccent,
              onPressed: _addExpense,
              child: const Text('Add'),
            )
          ]),
        ),
      ),
    );
  }
}
