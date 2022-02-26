import 'package:flutter/material.dart';
import 'event.dart';

class EventDetailsPage extends StatelessWidget {
  final EventModel event;
  const EventDetailsPage({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context){
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

  String textButtom = 'Suscribirse';
  Icon textIcon = Icon(Icons.subscriptions);
 
  changeText() {
    setState(() {
      textButtom = 'Suscrito'; 
      textIcon = Icon(Icons.subscriptions_outlined);
    });
    
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Evento'),
        backgroundColor: Color.fromARGB(255, 132, 43, 87),
        centerTitle: true,
      ),
      body:
      SingleChildScrollView(
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
              margin: EdgeInsets.only(left: 10, top:20),
              child: Text(
                event.description,
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => changeText(),
        icon: textIcon,
        backgroundColor: Color.fromARGB(255, 132, 43, 87),
        label: Text('$textButtom',
                    style:
                        TextStyle(color: Colors.white, fontSize: 16)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}