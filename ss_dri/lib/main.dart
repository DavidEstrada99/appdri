import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'Student.dart';
import 'login.dart';
import 'model/notification_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await NotificationService().init();
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
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new StudentHome(),
        '/login': (BuildContext context) => new MyApp(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
