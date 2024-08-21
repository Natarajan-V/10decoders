import 'package:application/data/category.dart';
import 'package:application/models/expense.model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ExpenseCard extends ConsumerWidget {
  final ExpenseModel data;

  const ExpenseCard({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = DateTime.fromMillisecondsSinceEpoch(data.dateTime ?? 0);
    return ListTile(
      tileColor: Colors.purple.withOpacity(.25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      subtitle: Text(Category.parse(data.category)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('₹ ${data.amount}'),
          Text(DateFormat('dd MMM yyyy').format(date))
        ],
      ),
    );
  }
}
