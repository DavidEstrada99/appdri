//import 'package:firebase_helpers/firebase_helpers.dart';
import 'dart:convert';


class EventModel{
  final String id;
  final String title;
  final String degree;
  final String description;
  final DateTime eventDate;

  EventModel({this.id, this.title, this.degree, this.description, this.eventDate});

  factory EventModel.fromMap(Map<String, dynamic> data) {
    if (data == null) return null;

    return EventModel(
      title: data['title'],
      description: data['body'],
      eventDate: data['FechaInicio'],
      //eventDate: DateTime.fromMillisecondsSinceEpoch(data['FechaInicio']),
      degree: data['highestDegree'],
    );
  }

  factory EventModel.fromDS(String id, Map<String,dynamic> data) {
    if (data == null) return null;

    return EventModel(
      id: id,
      title: data['title'],
      description: data['body'],
      eventDate: data['FechaInicio'].toDate(),
      //eventDate: DateTime.fromMillisecondsSinceEpoch(data['FechaInicio']),
      degree: data['highestDegree'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EventModel(title: $title, id: $id, description: $description, date: $eventDate, highestDegree: $degree)';
  }

  Map<String,dynamic> toMap() {
    return {
      "title":title,
      "id":id,
      "body": description,
      "FechaInicio":eventDate,
      //"FechaInicio":eventDate.millisecondsSinceEpoch,
      "highestDegree":degree,
    };
  }
}
