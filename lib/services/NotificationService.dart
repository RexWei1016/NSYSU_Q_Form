// lib/services/notification_service.dart
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_view_model.dart';

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
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
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
      print(' APNs Token: $apnsToken');
    }

    // 前景通知事件監聽
    FirebaseMessaging.onMessage.listen(_handleMessage);

    // 點擊通知打開 App 的事件
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("點擊通知打開 App: ${message.notification?.title}");
      _handleMessage(message);
    });

    // App 從 terminated 狀態啟動時，有通知可處理
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      print("從終止狀態啟動，處理初始通知: ${initialMessage.notification?.title}");
      // 確保在應用程式完全初始化後再處理通知
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleMessage(initialMessage);
      });
    }

    // 拿到 FCM token
    final token = await _fcm.getToken();
    print(' FCM Token: $token');
  }

  static Future<void> _handleMessage(RemoteMessage message) async {
    print("處理通知訊息: ${message.notification?.title}");
    await showLocalNotification(message);
  }

  static Future<void> showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    print("更新通知內容到 HomeViewModel: ${notification.title}");
    // 更新 HomeViewModel 中的通知內容
    if (navigatorKey.currentContext != null) {
      try {
        final homeViewModel = Provider.of<HomeViewModel>(
          navigatorKey.currentContext!,
          listen: false,
        );
        homeViewModel.updateNotification(
          notification.title ?? '',
          notification.body ?? '',
        );
        print("成功更新通知內容");
      } catch (e) {
        print("更新通知內容時發生錯誤: $e");
      }
    }

    // Android 通知樣式
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      '預設頻道',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher', // 設定通知圖示
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'), // 設定大圖示
      color: Color(0xFF4CAF50), // 設定通知顏色（綠色）
    );

    // iOS 通知樣式
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

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

// 全域導航鍵，用於在非 Widget 中存取 context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
