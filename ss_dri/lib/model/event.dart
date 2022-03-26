import 'dart:convert';

class EventModel{
  final String id;
  final String title;
  final String url;
  final String description;
  final DateTime eventDate;
  final bool suscription;

  EventModel({this.id, this.title, this.url, this.suscription, this.description, this.eventDate});


  factory EventModel.fromMap(Map<String, dynamic> data) {
    if (data == null) return null;

    return EventModel(
      url: data['link'],
      title: data['title'],
      description: data['body'],
      eventDate: data['FechaInicio'],
      suscription: data['Suscripcion'],
    );
  }

  factory EventModel.fromDS(String id, Map<String,dynamic> data) {
    if (data == null) return null;

    return EventModel(
      id: id,
      url: data['link'],
      title: data['title'],
      description: data['body'],
      eventDate: data['FechaInicio'].toDate(),
      suscription: data['Suscripcion'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EventModel(title: $title, id: $id, description: $description, url: $url, date: $eventDate, suscripción: $suscription)';
  }

  Map<String,dynamic> toMap() {
    return {
      "title":title,
      "id":id,
      "body": description,
      "link": url,
      "FechaInicio":eventDate,
      "Suscripcion":suscription,
    };
  }
}