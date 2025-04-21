// transport_page.dart (View)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/transport_view_model.dart';
import '../models/transport_record.dart';

class TransportPage extends StatefulWidget {
  const TransportPage({super.key});

  @override
  State<TransportPage> createState() => _TransportPageState();
}

class _TransportPageState extends State<TransportPage> {
  final stepsController = TextEditingController();
  final bikeController = TextEditingController();
  final publicController = TextEditingController();
  final motorcycleController = TextEditingController();


  @override
  void initState() {
    super.initState();
    final vm = context.read<TransportViewModel>();
    Future.microtask(() async {
      await vm.loadWeeklyData();
      await vm.fetchStepsFromHealth(); // ← 自動抓取今日步數
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransportViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('交通日誌'),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: stepsController,
              decoration: const InputDecoration(labelText: '今日步數', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: bikeController,
              decoration: const InputDecoration(labelText: '今日摩托車次數', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: motorcycleController,
              decoration: const InputDecoration(labelText: '今日摩托車次數', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: publicController,
              decoration: const InputDecoration(labelText: '今日公共交通次數', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final steps = int.tryParse(stepsController.text) ?? 0;
                final bike = int.tryParse(bikeController.text) ?? 0;
                final motorcycle = int.tryParse(motorcycleController.text) ?? 0;
                final pub = int.tryParse(publicController.text) ?? 0;

                final today = DateTime.now().toIso8601String().substring(0, 10);
                vm.submitToday(today, steps, bike, motorcycle, pub);

              },
              child: const Text('提交今日紀錄'),
            ),
            const SizedBox(height: 10),
            Text('今日步數：${vm.todaySteps}', style: const TextStyle(fontSize: 16)),
            Text('今日摩托車次數：${vm.todayBike}', style: const TextStyle(fontSize: 16)),
            Text('今日腳踏車次數：${vm.todayBike}', style: const TextStyle(fontSize: 16)),
            Text('今日公共交通次數：${vm.todayPublic}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('日期')),
                      DataColumn(label: Text('步數')),
                      DataColumn(label: Text('腳踏車')),
                      DataColumn(label: Text('摩托車')),
                      DataColumn(label: Text('公共交通')),
                    ],
                    rows: vm.weeklyRecords.map((e) => DataRow(cells: [
                      DataCell(Text(e.date.substring(5))),
                      DataCell(Text('${e.steps}')),
                      DataCell(Text('${e.bike}')),
                      DataCell(Text('${e.motorcycle}')),
                      DataCell(Text('${e.publicTransport}')),
                    ])).toList(),
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
