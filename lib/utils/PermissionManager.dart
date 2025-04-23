// lib/utils/permission_manager.dart
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static Future<void> requestAllPermissions() async {
    final statuses = await [
      Permission.activityRecognition,
      Permission.sensors,
      Permission.camera,
      Permission.location,
      Permission.notification,
    ].request();

    statuses.forEach((permission, status) {
      if (!status.isGranted) {
        debugPrint('$permission 未授權');
      }
    });
  }
}
