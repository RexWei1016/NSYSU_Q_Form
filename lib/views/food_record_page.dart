// lib/views/food_record_page.dart
import 'package:flutter/material.dart';

class FoodRecordPage extends StatefulWidget {
  const FoodRecordPage({super.key});

  @override
  State<FoodRecordPage> createState() => _FoodRecordPageState();
}

class _FoodRecordPageState extends State<FoodRecordPage> {
  final Map<String, String?> todayRecord = {
    '早餐': null,
    '午餐': null,
    '晚餐': null,
  };

  final List<String> options = ['一次性提袋', '非一次性提袋', '無用餐'];

  // 假設一週的紀錄資料
  final List<Map<String, dynamic>> weekData = [
    {'day': '一', '早餐': '一次性提袋', '午餐': '非一次性提袋', '晚餐': '無用餐'},
    {'day': '二', '早餐': '無用餐', '午餐': '一次性提袋', '晚餐': '非一次性提袋'},
    {'day': '三', '早餐': '非一次性提袋', '午餐': '非一次性提袋', '晚餐': '一次性提袋'},
    {'day': '四', '早餐': '一次性提袋', '午餐': '一次性提袋', '晚餐': '一次性提袋'},
    {'day': '五', '早餐': '無用餐', '午餐': '無用餐', '晚餐': '無用餐'},
    {'day': '六', '早餐': '非一次性提袋', '午餐': '非一次性提袋', '晚餐': '非一次性提袋'},
    {'day': '日', '早餐': '一次性提袋', '午餐': '非一次性提袋', '晚餐': '無用餐'},
  ];

  void updateMeal(String meal, String value) {
    setState(() {
      todayRecord[meal] = value;
    });
  }

  Widget buildMealSelector(String meal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(meal, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: options.map((opt) {
            final isSelected = todayRecord[meal] == opt;
            return ChoiceChip(
              label: Text(opt),
              selected: isSelected,
              selectedColor: Colors.green.shade200,
              onSelected: (_) => updateMeal(meal, opt),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('購餐紀錄'),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('今日紀錄', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...['早餐', '午餐', '晚餐'].map(buildMealSelector),
            const SizedBox(height: 10),
            const Text('一週紀錄', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('日')),
                  DataColumn(label: Text('早餐')),
                  DataColumn(label: Text('午餐')),
                  DataColumn(label: Text('晚餐')),
                ],
                rows: weekData.map((day) {
                  return DataRow(cells: [
                    DataCell(Text(day['day'])),
                    DataCell(Text(day['早餐'])),
                    DataCell(Text(day['午餐'])),
                    DataCell(Text(day['晚餐'])),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
