// lib/services/notification_service.dart
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();

  // 初始化 FCM 與本地通知
  static Future<void> init() async {
    // 啟用本地通知設定
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _local.initialize(initSettings);

    // FCM 權限請求（iOS 才會生效）
    await _fcm.requestPermission();

    // 前景通知處理
    FirebaseMessaging.onMessage.listen(_handleMessage);

    // 背景通知處理（點擊時觸發）
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // Android: 針對長時間未開啟 App 的狀況
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // 印出 token（測試用，可上傳至後端）
    final token = await _fcm.getToken();
    print('FCM Token: $token');
  }

  // 背景訊息處理器（必須是頂層函數）
  static Future<void> backgroundHandler(RemoteMessage message) async {
    await _showLocalNotification(message);
  }

  // 處理訊息（共用）
  static Future<void> _handleMessage(RemoteMessage message) async {
    await _showLocalNotification(message);
  }

  // 顯示通知
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      '預設頻道',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _local.show(
      0,
      notification.title,
      notification.body,
      notificationDetails,
    );
  }
}
