import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'event.dart';

class EventDetailsPageEmpty extends StatelessWidget {
  final EventModel event;
  const EventDetailsPageEmpty({Key key, this.event}) : super(key: key);

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

  String id;
  String textButtom;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Icon textIcon;

  changeText() {
    setState(() {
  //    guardar_pref('Suscrito',event.id);
      textButtom = 'Suscrito'; 
      textIcon = Icon(Icons.subscriptions_outlined);
    });
  }

  Future<void> guardar_pref(boton, id) async{
    SharedPreferences pref = await _prefs;

    await pref.setString('id', id);
    await pref.setString('boton', boton);
  }

  Future<void> mostrar_pref() async{
    SharedPreferences pref = await _prefs;

    textButtom = await pref.getString('boton');
    id = await pref.getString('id');

    print(id);

    if(id==''){
      if(id==null){
        textButtom = "Suscribirse";
        textIcon = Icon(Icons.subscriptions);
      }
    }
    print("id: "+id);
    textIcon = Icon(Icons.place);
  }
 
   @override
  void initState() {
    super.initState();
    if(event.suscription){
      textButtom = 'Suscrito';
      textIcon = Icon(Icons.subscriptions_outlined);
    }else{
 //     mostrar_pref();
      textButtom = 'Suscribirse';
      textIcon = Icon(Icons.subscriptions);
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
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Aviso'),
            content: const Text('Este evento es obligatorio y no necesitas suscribirte para recibir la notificación'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        ),
        icon: textIcon,
        backgroundColor: Color.fromARGB(255, 132, 43, 87),
        label: Text('$textButtom', style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}