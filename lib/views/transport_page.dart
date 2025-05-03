import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/transport_view_model.dart';

class TransportPage extends StatefulWidget {
  const TransportPage({super.key});

  @override
  State<TransportPage> createState() => _TransportPageState();
}

class _TransportPageState extends State<TransportPage> {
  final stepsController = TextEditingController();
  final bikeController = TextEditingController();
  final motorcycleController = TextEditingController();
  final publicController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final vm = context.read<TransportViewModel>();
    Future.microtask(() async {
      await vm.loadWeeklyData();
      await vm.fetchStepsFromHealth();

      stepsController.text = vm.todaySteps.toString();
      bikeController.text = vm.todayBike.toString();
      motorcycleController.text = vm.todayMotorcycle.toString();
      publicController.text = vm.todayPublic.toString();

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('今日紀錄', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildInputField('今日步數', stepsController),
            _buildInputField('今日腳踏車次數', bikeController),
            _buildInputField('今日摩托車次數', motorcycleController),
            _buildInputField('今日公共交通次數', publicController),
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
            const SizedBox(height: 20),
            const Text('一週紀錄', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildWeekTable(vm),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildWeekTable(TransportViewModel vm) {
    final weekDays = ['一', '二', '三', '四', '五', '六', '日'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('星期')),
          DataColumn(label: Text('步數')),
          DataColumn(label: Text('腳踏車')),
          DataColumn(label: Text('摩托車')),
          DataColumn(label: Text('公共交通')),
        ],
        rows: List.generate(7, (i) {
          final data = vm.weekRecords.length > i ? vm.weekRecords[i] : {};
          final isOdd = i % 2 == 1;
          final rowColor = isOdd ? Colors.grey.shade100 : null;

          return DataRow(
            color: rowColor != null
                ? MaterialStateProperty.all(rowColor)
                : null,
            cells: [
              DataCell(Text(weekDays[i])),
              DataCell(Text('${data['steps'] ?? '-'}')),
              DataCell(Text('${data['bike'] ?? '-'}')),
              DataCell(Text('${data['motorcycle'] ?? '-'}')),
              DataCell(Text('${data['public'] ?? '-'}')),
            ],
          );
        }),
      ),
    );
  }


}
