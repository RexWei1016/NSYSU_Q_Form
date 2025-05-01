// lib/utils/permission_manager.dart
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static Future<void> requestAllPermissions() async {
    final permissions = [
      Permission.location,
      Permission.notification,
      Permission.sensors,
      Permission.camera,
    ];

    for (final permission in permissions) {
      final status = await permission.request();
      if (!status.isGranted) {
        debugPrint('$permission 未授權');
      }
    }
  }
}
