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
          Container(
            color: Colors.green.shade100,
            padding: const EdgeInsets.all(16),
            child: Text(
              vm.announcement.message,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                '這裡可以顯示圖表、紀錄摘要等等',
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
          onPressed: vm.onProfilePressed,
        ),
        const SizedBox(height: 10),
        FloatingActionButton.extended(
          heroTag: 'transport',
          label: const Text('交通方法日誌'),
          icon: const Icon(Icons.directions_bus),
          onPressed: vm.onTransportPressed,
        ),
        const SizedBox(height: 10),
        FloatingActionButton.extended(
          heroTag: 'food',
          label: const Text('購餐紀錄'),
          icon: const Icon(Icons.fastfood),
          onPressed: vm.onFoodPressed,
        ),
      ],
    );
  }
}
