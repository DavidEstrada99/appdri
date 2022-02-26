import 'package:firebase_helpers/firebase_helpers.dart';
import 'event.dart';

final eventDBS = DatabaseService<EventModel>("Eventos/DRI/evento", fromDS: (id,data) => EventModel.fromDS(id, data), toMap:(event) => event.toMap(),);