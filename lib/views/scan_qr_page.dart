import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_view_model.dart';

class ScanQRPage extends StatefulWidget {
  const ScanQRPage({super.key});

  @override
  State<ScanQRPage> createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  final TextEditingController manualController = TextEditingController();
  bool _scanned = false;

  Future<void> _handleJoinStudy(BuildContext context, String studyId) async {
    final vm = context.read<ProfileViewModel>();
    var profile = vm.profile;

    if (profile.userId.isEmpty) {
      profile = await vm.loadProfileWithReturn();
    }

    await vm.syncToServerIfNeeded();

    final result = await vm.joinStudy(studyId); // ✅ null 代表成功，否則是錯誤訊息

    if (!context.mounted) return;

    final isSuccess = result == null;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSuccess ? '✅ 已成功加入研究：$studyId' : '❌ 加入研究失敗：$result',
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );

    if (isSuccess) {
      await Future.delayed(const Duration(seconds: 2));
      if (context.mounted) Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('掃描加入研究'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: MobileScanner(
              onDetect: (capture) async {
                if (_scanned) return; // 防止重複掃描
                _scanned = true;

                final barcode = capture.barcodes.first;
                final studyId = barcode.rawValue;

                if (studyId != null) {
                  await _handleJoinStudy(context, studyId);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('無效的 QRCode')),
                  );
                  _scanned = false;
                }
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  '無法掃描？請手動輸入研究代碼：',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: manualController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '研究 ID',
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    final inputId = manualController.text.trim();
                    if (inputId.isNotEmpty) {
                      _handleJoinStudy(context, inputId);
                    }
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('加入研究'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
