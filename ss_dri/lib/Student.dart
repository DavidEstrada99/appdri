import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final Map<DateTime, List> _holidays = {
  DateTime(2021, 1, 1): ['New Year\'s Day'],
  DateTime(2021, 1, 6): ['Epiphany'],
  DateTime(2021, 2, 14): ['Valentine\'s Day'],
  DateTime(2021, 4, 21): ['Easter Sunday'],
  DateTime(2021, 4, 22): ['Easter Monday'],
};

class StudentHome extends StatefulWidget {
  StudentHome({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<StudentHome> with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Eventos').snapshots();

  /* Lectura de la base de datos. solo se lee una vez*/ 
  /*Future buildEvents() async {
    final firestoreInstance = FirebaseFirestore.instance;
    try {
      //Example event
      // final _selectedDay = DateTime.now();
      // _events = {
      //   _selectedDay.subtract(Duration(days: 30)): [
      //     'Event A0',
      //     'Event B0',
      //     'Event C0'
      //   ],
      // };
      firestoreInstance.collection("Eventos").get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          //por cada documento
          var data = result.data();
          List<DateTime> datetimeList = [];
          String title = "";
          String body = "";
          int id = -1;
          data.forEach((key, value) {
            //por cada elemento en el documento
            if (key == "FechaInicio") {
              for (var day in value) {
                //por cada fecha
                var eventDate =
                    new DateTime.fromMillisecondsSinceEpoch(day.seconds * 1000);
                datetimeList.add(eventDate);
              }
            }
            if (key == "title") {
              title = value.toString();
            }
            if (key == "body") {
              body = value.toString();
            }
            if (key == "id") {
              id = value;
            }
          });
          for (var date in datetimeList) {
            //llenar el objeto
            if (_events.containsKey(date)) {
              _events.update(date, (value) {
                var arr = [title, body, id];
                var val = value;
                val.add(arr);
                return val;
              });
            } else {
              var arr = [title, body, id];
              _events.addAll({
                date: [arr]
              });
            }
          }
          setState(() {
            _events = _events;
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }*/

  @override
  void initState() {
    super.initState();
    //buildEvents();
    realTime();
    final _selectedDay = DateTime.now();
    _events = {};
    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(microseconds: 400));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onvisibeDaysChanged $first $last $format');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  /*Lectura a tiempo real de la base. Detecta cambios*/ 
  void realTime() {
    _usersStream.listen((snapshotData) {
      if (snapshotData.size <= 0) {
        return;
      }
      var docsSnapshot = snapshotData.docChanges;
      docsSnapshot.forEach((element) {
        print(element.type);
        if (element.type == DocumentChangeType.added ||
            element.type == DocumentChangeType.modified) {
          var docData = element.doc.data();
          var docDataMap = Map<String, dynamic>.from(docData);
          // print(docDataMap);
          List<DateTime> datetimeList = [];
          String title = "";
          String body = "";
          int id = -1;
          docDataMap.forEach((key, value) {
            //por cada elemento en el documento
            if (key == "FechaInicio") {
              for (var day in value) {
                //por cada fecha
                var eventDate =
                    new DateTime.fromMillisecondsSinceEpoch(day.seconds * 1000);
                datetimeList.add(eventDate);
              }
            }
            if (key == "title") {
              title = value.toString();
            }
            if (key == "body") {
              body = value.toString();
            }
            if (key == "id") {
              id = value;
            }
          });
          print(datetimeList);
          try {
            var event = Map<DateTime, List<dynamic>>.from(_events);
            for (var date in datetimeList) {
              if (event.containsKey(date)) {
                event.update(date, (value) {
                  var val = value;
                  if (value[0].runtimeType.toString() == "String" &&
                      int.parse(value[2].toString()) == id) {
                    var arr = [title, body, id];
                    val = arr;
                  } else if (value[0].runtimeType.toString() != "String") {
                    for (var i = 0; i < value.length; i++) {
                      if (value[i][2] == id) {
                        val[i] = [title, body, id];
                      }
                    }
                  }
                  return val;
                });
              } else {
                var arr = [title, body, id];
                event.addAll({
                  date: [arr]
                });
              }
            }
            setState(() {
              _events = event;
            });
          } catch (e) {
            print(e);
          }
        } else if (element.type == DocumentChangeType.removed) {
          var docData = element.doc.data();
          var docDataMap = Map<String, dynamic>.from(docData);
          List<DateTime> datetimeList = [];
          int id = -1;
          docDataMap.forEach((key, value) {
            //por cada elemento en el documento
            if (key == "FechaInicio") {
              for (var day in value) {
                //por cada fecha
                var eventDate =
                    new DateTime.fromMillisecondsSinceEpoch(day.seconds * 1000);
                datetimeList.add(eventDate);
              }
            }
            if (key == "id") {
              id = value;
            }
          });
          for (var date in datetimeList) {
            print(_events.containsKey(date));
            if (_events.containsKey(date)) {
              print("sí existe");
              try {
                _events.update(date, (value) {
                  var list = value;
                  print(list);
                  list.removeWhere((element) => element[2] == id);
                  print(list);
                  return list;
                });
              } catch (e) {
                print(e);
              }
            }
          }
          setState(() {
            _events = _events;
          });
        }
      });
    });
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 132, 43, 87),
          centerTitle: true,
          title: Text('Bienvenido'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 132, 43, 87),
                ),
                child: Text(
                  'D.R.I',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 80,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Profile'),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Cerrar sesión'),
                onTap: () {
                  _signOut();
                },
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildTableCalendar(),
            const SizedBox(
              height: 8.0,
            ),
            const SizedBox(
              height: 8.0,
            ),
            Expanded(child: _buildEventList()),
          ],
        ));
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
          selectedColor: Colors.deepOrange[400],
          todayColor: Colors.deepOrange[200],
          markersColor: Colors.deepOrange[700],
          outsideDaysVisible: false),
      headerStyle: HeaderStyle(
          formatButtonTextStyle:
              TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
          formatButtonDecoration: BoxDecoration(
              color: Colors.deepOrange[400],
              borderRadius: BorderRadius.circular(16.0))),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((e) => Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 0.8),
                    borderRadius: BorderRadius.circular(12.0)),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        e[0].toString(),
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        e[1].toString(),
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 10, bottom: 10, top: 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 132, 43, 87),
                            borderRadius: BorderRadius.circular(20)),
                        child: TextButton(
                            onPressed: () =>
                                print(e), //lanzar la suscripción a firebase
                            child: Text(
                              "Suscribirse",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            )))
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class Student extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 132, 43, 87),
          centerTitle: true,
          title: Text('Bienvenido'),
        ),
        body: Text('Texto'));
  }
}