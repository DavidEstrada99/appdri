import 'package:flutter/material.dart';
import 'login.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

// } => runApp(MyApp());

class MyApp extends StatelessWidget {
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
      debugShowCheckedModeBanner: false,
    );
  }
}

// class Home extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _HomeState();
//   }
// }

// class _HomeState extends State<Home> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("My flutter app"),
//       ),
//       body: Center(
//         child: Text("You have press the button $_count times."),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: Container(
//           height: 50.0,
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => setState(() {
//           _count++;
//         }),
//         tooltip: 'Increment Counter',
//         child: Icon(Icons.add),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }
// }

// class RandomWords extends StatefulWidget {
//   @override
//   _RandomWordsState createState() => _RandomWordsState();
// }

// class _RandomWordsState extends State<RandomWords> {
//   @override
//   Widget build(BuildContext context) {
//     final wordPair = WordPair.random();
//     return Text(wordPair.asPascalCase);
//   }
// }
