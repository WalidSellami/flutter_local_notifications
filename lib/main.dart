import 'package:flutter/material.dart';
import 'package:notifications_test/Notifications.dart';
import 'package:notifications_test/TestScreen.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Notifications().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TestScreen(),
    );
  }
}