import 'package:flutter/material.dart';
import 'package:notifications_test/Notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {

  Future<void> notificationTest({required bool isInstant}) async {
    final status = await Permission.notification.status;

    // Ask permission if not permanently denied
    if (status.isDenied) {
      final result = await Permission.notification.request();
      if (result.isGranted) {
        // Short delay to give OS time to update permission status
        await Future.delayed(Duration(seconds: 1));
        await notificationTest(isInstant: isInstant);
      }
    }

    // Permanently Denied
    else if (status.isPermanentlyDenied) {

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            clipBehavior: Clip.antiAlias,
            titleTextStyle: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.6,
              color: Colors.black
            ),
            contentTextStyle: TextStyle(
                fontSize: 16.0,
                letterSpacing: 0.6,
                height: 1.5,
                color: Colors.black
            ),
            title: Text('Enable Notifications', textAlign: TextAlign.center),
            content: Text(
              'Notifications are disabled. Please enable them manually in system settings.',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await openAppSettings();
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: Text('Open Settings'),
              ),
            ],
          );
        },
      );
    }

    // Already granted
    else {
      if (isInstant) {
        await Notifications().showInstantNotification(
          title: 'Instant Notification',
          body: 'This is an instant notify test',
        );
      } else {
        // Request schedule permission if needed
        if (await Permission.scheduleExactAlarm.isDenied) {
          await Permission.scheduleExactAlarm.request();
        }

        await Notifications().showScheduleNotification(
          title: 'Schedule Notification',
          body: 'This is a schedule notify test',
        );
      }
    }
  }

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
                await notificationTest(isInstant: true);
              },
              child: Text(
                'Simple Notification',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
            SizedBox(height: 30.0),
            FilledButton(
              onPressed: () async {
                await notificationTest(isInstant: false);
              },
              child: Text(
                'Schedule Notification',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
