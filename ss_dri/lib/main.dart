import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'Student.dart';
import 'login.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//this function is used to receive notifications by firebase cloud messaging
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification.title,
      message.notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
          icon: message.notification.android?.smallIcon,
        ),
      ));
}

//android channel is required to show notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
);

final flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //here add notifications
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

// } => runApp(MyApp());
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    var initializationSettingsAndroid = AndroidInitializationSettings('ipn');
    var initalizationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    // , iOS: initializationSettingdIOS);
    flutterLocalNotificationsPlugin.initialize(initalizationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: 'launch_background',
              ),
            ));
      }
    });

    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formación de líderes',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 132, 43, 87),
          centerTitle: true,
          title: Text(
            'Iniciar Sesión',
          ),
        ),
        body: new Login(),
      ),
      routes: <String,WidgetBuilder>{
        '/home': (BuildContext context) => new StudentHome(),
        '/login': (BuildContext context) => new MyApp(),
      },
      debugShowCheckedModeBanner: false,
    );
  }

  getToken() async {
    String token = await FirebaseMessaging.instance.getToken();
    print(token);
  }
}
