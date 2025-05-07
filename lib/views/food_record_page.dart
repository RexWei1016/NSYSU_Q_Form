// lib/views/food_record_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/food_record_view_model.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class FoodRecordPage extends StatefulWidget {
  const FoodRecordPage({super.key});

  @override
  State<FoodRecordPage> createState() => _FoodRecordPageState();
}

class _FoodRecordPageState extends State<FoodRecordPage> {
  final List<String> options = ['一次性提袋', '非一次性提袋', '無用餐'];
  late String today;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = context.read<FoodRecordViewModel>();
      await vm.loadTodayRecords(today);
      await vm.loadWeekRecords();
      setState(() => isLoading = false);
    });
  }

  void updateMeal(String meal, String value) async {
    final vm = context.read<FoodRecordViewModel>();
    await vm.updateMeal(today, meal, value);
    await vm.loadWeekRecords(); // 確保下方一週紀錄刷新
  }

  Widget buildMealSelector(String meal) {
    final vm = context.watch<FoodRecordViewModel>();
    final selected = vm.todayRecords.firstWhereOrNull((r) => r.mealType == meal);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(meal, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: options.map((opt) {
            final isSelected = selected?.bagType == opt;
            return ChoiceChip(
              label: Text(opt),
              selected: isSelected,
              selectedColor: Colors.green.shade200,
              onSelected: (_) {
                if (DateFormat('yyyy-MM-dd').format(DateTime.now()) == today) {
                  updateMeal(meal, opt);
                }
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildWeekTable() {
    final vm = context.watch<FoodRecordViewModel>();
    final days = ['一', '二', '三', '四', '五', '六', '日'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('星期')),
          DataColumn(label: Text('早餐')),
          DataColumn(label: Text('午餐')),
          DataColumn(label: Text('晚餐')),
        ],
        rows: List.generate(7, (index) {
          final record = vm.weekRecords.length > index ? vm.weekRecords[index] : {};
          final isOdd = index % 2 == 1;
          final color = isOdd ? Colors.grey.shade100 : null;

          return DataRow(
            color: color != null ? MaterialStateProperty.all(color) : null,
            cells: [
              DataCell(Text(days[index])),
              DataCell(Text(record['早餐'] ?? '-')),
              DataCell(Text(record['午餐'] ?? '-')),
              DataCell(Text(record['晚餐'] ?? '-')),
            ],
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final meals = ['早餐', '午餐', '晚餐'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('購餐紀錄'),
        backgroundColor: Colors.green.shade700,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('今日紀錄', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...meals.map(buildMealSelector),
            const SizedBox(height: 20),
            const Text('一週紀錄', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            buildWeekTable(),
          ],
        ),
      ),
    );
  }
}
