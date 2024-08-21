import 'package:application/home/pages/images.dart';
import 'package:application/home/widgets/add_expense.dart';
import 'package:application/home/widgets/expense.dart';
import 'package:application/providers/hive.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  get itemCount => null;

  static const TextStyle _style = TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    final logic = ref.watch(hiveProvider);
    final list = logic.fetchExpense;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ImagesPage()),
            ),
            icon: const Icon(Icons.image),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [
            const Expanded(child: Text('Total Expense', style: _style)),
            Text('₹ ${logic.getTotalExpense}', style: _style)
          ]),
          const SizedBox(height: 16),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (_, i) => ExpenseCard(data: list[i]),
            separatorBuilder: (_, i) => const SizedBox(height: 16),
            itemCount: list.length,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => const AddExpense(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
