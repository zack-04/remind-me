import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminder_app/screens/home_screen.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Schedule Reminder',
      'Drink water',
      importance: Importance.max,
      priority: Priority.max,
    );
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    return platformChannelSpecifics;
  }

  Future init(BuildContext context, String email) async {
    tz.initializeTimeZones();
    final DarwinInitializationSettings ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      defaultPresentSound: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    final android = AndroidInitializationSettings("icon");
    final settings = InitializationSettings(android: android, iOS: ios);
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => HomeScreen(),
        //   ),
        // );
        onNotifications.add(details as String?);
      },
    );
  }

  void requestIOSPermission() {
    _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future onDidReceiveLocalNotification(
      int? id, String? title, String? content, String? payload) async {
    return Text('Welcome');
  }

  static Future showNotifications({
    int id = 0,
    String? title,
    String? description,
    String? payload,
    required DateTime dateTime,
  }) async {
    if (dateTime.isBefore(DateTime.now())) {
      dateTime = dateTime.add(
        Duration(days: 1),
      );
    }
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_DESCRIPTION',
      importance: Importance.max,
      priority: Priority.max,
    );
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    _notifications.show(
      id,
      title,
      description,
      platformChannelSpecifics,
    );
  }
}
