import 'event.dart';
import 'notification_service.dart';
import 'package:flutter/material.dart';
import 'package:link_text/link_text.dart';
import 'package:timezone/timezone.dart' as tz;

class EventDetailsPage extends StatelessWidget {
  final EventModel event;
  const EventDetailsPage({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UpdateText(event: event);
  }
}

class UpdateText extends StatefulWidget {
  final EventModel event;
  const UpdateText({Key key, this.event}) : super(key: key);

  @override
  _UpdateTextState createState() => _UpdateTextState(event: this.event);
}

class _UpdateTextState extends State {
  EventModel event;
  _UpdateTextState({this.event});

  String _url;
  String textButtom = 'Suscribirse';
  Icon textIcon = Icon(Icons.subscriptions);

  changeText() {
    setState(() {
      textButtom = 'Suscrito';
      textIcon = Icon(Icons.subscriptions_outlined);
    });
  }

   @override
  void initState() {
    super.initState();
    if(event.url==""){
      _url="";
    }else{
      _url='http://'+event.url;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Evento'),
        backgroundColor: Color.fromARGB(255, 132, 43, 87),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 5),
              child: Text(
                event.title,
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, top: 20),
              child: Text(
                event.description,
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, top: 20),
              child: LinkText(
                _url,
                textAlign: TextAlign.center,
                // You can optionally handle link tap event by yourself
                // onLinkTap: (url) => ...
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          changeText();
          int id = 0;
          for (int i = 0; i < event.id.length; i++) {
            id = id + event.id.codeUnitAt(i);
          }
          print("El id es: $id");
          NotificationService().CreatingNotifications(
              id, event.title, event.description, event.eventDate);
        },
        icon: textIcon,
        backgroundColor: Color.fromARGB(255, 132, 43, 87),
        label: Text('$textButtom',
            style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}