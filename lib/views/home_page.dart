import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../utils/PermissionManager.dart';
import '../viewmodels/home_view_model.dart';
import '../viewmodels/profile_view_model.dart';
import '../viewmodels/transport_view_model.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await PermissionManager.requestAllPermissions(); // 呼叫集中管理的權限工具
      context.read<ProfileViewModel>().loadProfileWithReturn();
      await context.read<TransportViewModel>().fetchStepsFromHealth();
    });
  }


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
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                final profileVM = context.read<ProfileViewModel>();

                // 顯示等待畫面
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                );

                try {
                  final urls = await profileVM.getMySurveys();

                  // 關閉等待畫面
                  Navigator.of(context).pop();

                  if (urls.isNotEmpty) {
                    final url = urls.first;
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('無法開啟問卷連結')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('目前沒有可填寫的問卷')),
                    );
                  }
                } catch (e) {
                  Navigator.of(context).pop();
                  final errorMessage = e.toString().contains('UUID 為空')
                      ? '請先設定個人基本資料（UUID）'
                      : '取得問卷連結時發生錯誤';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage)),
                  );
                  debugPrint('錯誤：$e');
                }
              },
              icon: const Icon(Icons.assignment),
              label: const Text('填寫今日問卷'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ),
          // ElevatedButton(
          //   onPressed: () async {
          //     const testUrl = 'https://www.google.com';
          //     final uri = Uri.parse(testUrl);
          //     if (await canLaunchUrl(uri)) {
          //       await launchUrl(uri, mode: LaunchMode.externalApplication);
          //     } else {
          //       debugPrint('❌ 無法開啟 Google 網頁');
          //     }
          //   },
          //   child: const Text('測試開啟 Google'),
          // ),
          Consumer<TransportViewModel>(
            builder: (context, vm, child) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      '今日步數',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.shade100,
                        border: Border.all(color: Colors.green, width: 4),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${vm.todaySteps}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

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
