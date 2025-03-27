//  lib/views/transport_page.dart
import 'package:flutter/material.dart';

class TransportPage extends StatefulWidget {
  const TransportPage({super.key});

  @override
  State<TransportPage> createState() => _TransportPageState();
}

class _TransportPageState extends State<TransportPage> {
  final TextEditingController stepsController = TextEditingController();
  final TextEditingController bikeController = TextEditingController();
  final TextEditingController publicTransportController = TextEditingController();

  int todaySteps = 0;
  int todayBike = 0;
  int todayPublic = 0;

  // 假設一週的資料（可改成從資料庫讀取）
  final List<Map<String, dynamic>> weekData = [
    {'day': '一', 'steps': 1200, 'bike': 2, 'public': 1},
    {'day': '二', 'steps': 1600, 'bike': 1, 'public': 2},
    {'day': '三', 'steps': 1500, 'bike': 3, 'public': 0},
    {'day': '四', 'steps': 1100, 'bike': 1, 'public': 1},
    {'day': '五', 'steps': 1800, 'bike': 0, 'public': 2},
    {'day': '六', 'steps': 1000, 'bike': 2, 'public': 1},
    {'day': '日', 'steps': 900,  'bike': 1, 'public': 0},
  ];

  void submitTodayRecord() {
    setState(() {
      todaySteps = int.tryParse(stepsController.text) ?? 0;
      todayBike = int.tryParse(bikeController.text) ?? 0;
      todayPublic = int.tryParse(publicTransportController.text) ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('交通日誌'),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔼 輸入區提前
            TextField(
              controller: stepsController,
              decoration: const InputDecoration(
                labelText: '今日步數',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: bikeController,
              decoration: const InputDecoration(
                labelText: '今日摩托車次數',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: publicTransportController,
              decoration: const InputDecoration(
                labelText: '今日公共交通次數',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: submitTodayRecord,
              child: const Text('提交今日紀錄'),
            ),
            const SizedBox(height: 10),
            Text('今日步數：$todaySteps', style: const TextStyle(fontSize: 16)),
            Text('今日摩托車次數：$todayBike', style: const TextStyle(fontSize: 16)),
            Text('今日公共交通次數：$todayPublic', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            // ⬇️ 一週統計表格
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('日')),
                      DataColumn(label: Text('步數')),
                      DataColumn(label: Text('摩托車')),
                      DataColumn(label: Text('公共交通')),
                    ],
                    rows: weekData.map((day) {
                      return DataRow(cells: [
                        DataCell(Text(day['day'])),
                        DataCell(Text('${day['steps']}')),
                        DataCell(Text('${day['bike']}')),
                        DataCell(Text('${day['public']}')),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
