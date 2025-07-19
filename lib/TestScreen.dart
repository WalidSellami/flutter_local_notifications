import 'package:flutter/material.dart';
import 'package:notifications_test/Notifications.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () async {
                await Notifications().showInstantNotification(
                    title: 'Instant Notification',
                    body: 'This is an instant notify test');
              },
              child: Text(
                'Simple Notification',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            FilledButton(
              onPressed: () async {
                await Notifications().showScheduleNotification(
                    title: 'Schedule Notification',
                    body: 'This is a schedule notify test');
              },
              child: Text(
                'Schedule Notification',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
