// lib/services/notification_service.dart
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("背景收到通知: ${message.notification?.title}");
  await NotificationService.showLocalNotification(message);
}

class NotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Android 設定
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS 設定：初始化通知
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false, // 初始不請求，在下面統一處理
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings, // ✅ 加入 iOS 初始化
    );

    await _local.initialize(initSettings);

    // iOS / Android 通知權限請求
    await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // iOS 取得 APNs Token（可選）
    if (Platform.isIOS) {
      final apnsToken = await _fcm.getAPNSToken();
      print('🍎 APNs Token: $apnsToken');
    }

    // 前景通知事件監聽
    FirebaseMessaging.onMessage.listen(_handleMessage);

    // 點擊通知打開 App 的事件
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // App 從 terminated 狀態啟動時，有通知可處理
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // 拿到 FCM token
    final token = await _fcm.getToken();
    print('📱 FCM Token: $token');
  }

  static Future<void> _handleMessage(RemoteMessage message) async {
    await showLocalNotification(message);
  }

  static Future<void> showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    // Android 通知樣式
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      '預設頻道',
      importance: Importance.max,
      priority: Priority.high,
    );

    // iOS 通知樣式
    const iosDetails = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _local.show(
      0,
      notification.title,
      notification.body,
      notificationDetails,
    );
  }
}
