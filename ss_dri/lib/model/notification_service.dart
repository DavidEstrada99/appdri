import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ipn');

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null, macOS: null);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /*Future selectNotification(String payload) async {
    //Handle notification tapped logic here
  }*/
  void CreatingNotifications(
      int id, String title, String body, DateTime day) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            '1', 'D.R.I', 'Instituto Politecnico Nacional',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    print("Creando notificacion");
    /*await flutterLocalNotificationsPlugin
        .show(id, title, body, platformChannelSpecifics, payload: 'data');*/

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(day, tz.local).add(const Duration(seconds: 5)),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
    print("Notificacion creada");
  }

  void DeletingNotifications(int id) async {
    /*const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            '1', 'D.R.I', 'Instituto Politecnico Nacional',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);*/
    print("Eliminando  notificacion");
    /*await flutterLocalNotificationsPlugin
        .show(id, title, body, platformChannelSpecifics, payload: 'data');*/

    await flutterLocalNotificationsPlugin.cancel(id);
    print("Notificacion Eliminada");
  }
}
