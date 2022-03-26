import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'model/event_firestore_service.dart';
import 'package:flutter/material.dart';
import 'model/view_event_empty.dart';
import 'package:intl/intl.dart';
import 'model/view_event.dart';
import 'model/event.dart';


final Map<DateTime, List> _holidays = {
  DateTime(2022, 1, 1): ['New Year\'s Day'],
  DateTime(2022, 1, 6): ['Epiphany'],
  DateTime(2022, 2, 14): ['Valentine\'s Day'],
  DateTime(2022, 4, 21): ['Easter Sunday'],
  DateTime(2022, 4, 22): ['Easter Monday'],
};

class StudentHome extends StatefulWidget {
  StudentHome({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<StudentHome> with TickerProviderStateMixin {
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
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

  /*Agrupa eventos por fechas. Detecta cambios*/ 
  Map<DateTime, List<dynamic>> _groupEvents(List<EventModel> events) {
    Map<DateTime, List<dynamic>> data = {};

    events.forEach((event) { 
      DateTime date = DateTime(event.eventDate.year, event.eventDate.month, event.eventDate.day, 12);
      if(data[date] == null) data[date] = [];
      data[date].add(event);
    });
    return data;
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
      body: StreamBuilder<List<EventModel>>(
        stream: eventDBS.streamList(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            List<EventModel> allEvents = snapshot.data;
            if(allEvents.isNotEmpty){
              _events = _groupEvents(allEvents);
            }
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTableCalendar(),
                const SizedBox(
                  height: 8.0,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                ..._selectedEvents.map((event) => ListTile(
                  title: Text(event.title),
                  subtitle: Text(DateFormat("EEEE, dd MMMM, yyyy",'es_ES').format(event.eventDate)),
                  onTap: () {
                    if(event.suscription){  //evento con notificación obligatoria.
                      Navigator.push(context, MaterialPageRoute( 
                        builder: (_) => EventDetailsPageEmpty( event: event,)));
                    }else{                  //evento con notificación activable.
                      Navigator.push(context, MaterialPageRoute( 
                        builder: (_) => EventDetailsPage( event: event,)));
                    }
                  },
                )),
              ],
            ),
          );
        }
      )
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      locale: 'es_ES',
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
}