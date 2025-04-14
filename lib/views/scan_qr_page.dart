// lib/views/scan_qr_page.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_view_model.dart';

class ScanQRPage extends StatelessWidget {
  const ScanQRPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('掃描加入研究'),
        backgroundColor: Colors.green,
      ),
      body: MobileScanner(
        onDetect: (capture) async {
          final barcode = capture.barcodes.first;
          final studyId = barcode.rawValue;

          if (studyId != null) {
            await context.read<ProfileViewModel>().joinStudy(studyId);
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('已加入研究：$studyId')),
              );
            }
          }
        },
      ),
    );
  }
}
