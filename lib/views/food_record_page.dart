// lib/views/food_record_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/food_sync_service.dart';
import '../viewmodels/food_record_view_model.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import '../viewmodels/profile_view_model.dart';

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

  Future<void> submitRecords() async {
    final vm = context.read<FoodRecordViewModel>();
    final profile = context.read<ProfileViewModel>().profile;
    final uuid = profile.userId;

    if (vm.pendingUpdates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('請先選擇用餐記錄')),
      );
      return;
    }

    // 顯示處理中的對話框
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await vm.submitPendingUpdates(today, uuid);
      // 關閉處理中的對話框
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('記錄已成功提交')),
        );
      }
    } catch (e) {
      // 關閉處理中的對話框
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('提交失敗：$e')),
        );
      }
    }
  }

  Widget buildMealSelector(String meal) {
    final vm = context.watch<FoodRecordViewModel>();
    final selected = vm.todayRecords.firstWhereOrNull((r) => r.mealType == meal);
    final pendingValue = vm.pendingUpdates[meal];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(meal, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: options.map((opt) {
            final isSelected = pendingValue == opt || (selected?.bagType == opt && pendingValue == null);
            return ChoiceChip(
              label: Text(opt),
              selected: isSelected,
              selectedColor: Colors.green.shade200,
              onSelected: (_) {
                if (DateFormat('yyyy-MM-dd').format(DateTime.now()) == today) {
                  vm.updatePendingMeal(meal, opt);
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
    final vm = context.watch<FoodRecordViewModel>();
    
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
                  if (vm.pendingUpdates.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: submitRecords,
                        icon: const Icon(Icons.send),
                        label: const Text('提交記錄'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(200, 48),
                        ),
                      ),
                    ),
                  ],
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
