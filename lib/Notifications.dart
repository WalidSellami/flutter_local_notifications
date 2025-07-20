import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Notifications {

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings android = const AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );

  final DarwinInitializationSettings ios = const DarwinInitializationSettings();


  Future<void> init() async {

    // For Schedule Notifications
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    InitializationSettings settings = InitializationSettings(
        android: android,
        iOS: ios
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings
    );

    // Android 13+ permission
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // iOS permission
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Schedule Notifications permission For Android
    if (Platform.isAndroid) {

     await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
         ?.requestExactAlarmsPermission();

    }

  }


  Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        'instant_notification_channel_id',
        'Instant notifications',
        channelDescription: 'Instant notification channel',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        enableLights: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }


  Future<void> showScheduleNotification({
    required String title,
    required String body,
  }) async {
    var now = tz.TZDateTime.now(tz.local);
    var scheduleDate = now.add(Duration(seconds: 3));


    NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        'schedule_notification_channel_id',
        'Schedule notifications',
        channelDescription: 'Schedule notification channel',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        enableLights: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      title,
      body,
      scheduleDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }




}