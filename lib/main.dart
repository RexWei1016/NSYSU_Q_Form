import 'package:flutter/material.dart';
import 'package:nsysu_q_form/services/NotificationService.dart';
import 'package:nsysu_q_form/viewmodels/food_record_view_model.dart';
import 'package:nsysu_q_form/viewmodels/transport_view_model.dart';
import 'package:nsysu_q_form/views/food_record_page.dart';
import 'package:provider/provider.dart';
import 'views/home_page.dart';
import 'viewmodels/home_view_model.dart';
import 'viewmodels/profile_view_model.dart';
import 'views/profile_page.dart';
import 'views/transport_page.dart';
import 'views/food_record_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 背景推播處理器註冊
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await NotificationService.init(); // 初始化通知服務

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => TransportViewModel()),
        ChangeNotifierProvider(create: (_) => FoodRecordViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '永續APP',
      initialRoute: '/',
      routes: {
        '/': (_) => const HomePage(),
        '/profile': (_) => const ProfilePage(),
        '/transport': (_) => const TransportPage(),
        '/food_record': (_) => const FoodRecordPage(),
      },
    );
  }
}