import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('永續APP'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 🔔 公告區塊
          Card(
            margin: const EdgeInsets.all(12),
            color: Colors.yellow.shade100,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📢 公告訊息',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    vm.announcement.message,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton.icon(
              onPressed: () => vm.onScanPressed(context),
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('掃描 QR 加入研究'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ),

          // 🔧 可放其他內容
          const Expanded(
            child: Center(
              child: Text(
                '這裡...可以顯示圖表、紀錄摘要等等 (預計)',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: _buildFAB(context, vm),
    );
  }

  Widget _buildFAB(BuildContext context, HomeViewModel vm) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.extended(
          heroTag: 'profile',
          label: const Text('個人基本資料'),
          icon: const Icon(Icons.person),
          onPressed: () => vm.onProfilePressed(context),

        ),
        const SizedBox(height: 10),
        FloatingActionButton.extended(
          heroTag: 'transport',
          label: const Text('交通方法日誌'),
          icon: const Icon(Icons.directions_bus),
          onPressed: () => vm.onTransportPressed(context),

        ),
        const SizedBox(height: 10),
        FloatingActionButton.extended(
          heroTag: 'food',
          label: const Text('購餐紀錄'),
          icon: const Icon(Icons.fastfood),
          onPressed: () => vm.onFoodPressed(context),
        ),
      ],
    );
  }
}
