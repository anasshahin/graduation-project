import 'dart:io';

import 'package:flutter/material.dart';

abstract class Book {
 String ? title;
 File ? image;
 String ? imageUrl;
 String ? type;
 String ? details;
 Map<String, dynamic> toJson() ;

}
class News with ChangeNotifier implements Book {
  String ?department;
  String ?college;
@override
File? image;
@override
String ?details;
@override
String? imageUrl;
@override
String? title;
 @override
 String ? type;
 News({this.details,this.title, this.image, this.imageUrl,
      this.department, this.college,this.type});
 News.fromJson(Map<String, dynamic> json) {
  details = json['details'];
  title = json['title'];
  imageUrl = json['imageUrl'];
  department = json['department'];
  college = json['college'];
  type = json['type'];

 }

 @override
  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['details'] = details;
  data['title'] = title;
  data['imageUrl'] = imageUrl;
  data['department'] = department;
  data['college'] = college;
  data['type'] = type;

  return data;
 }


}
class Event with ChangeNotifier implements Book{
  @override
  File? image;

  @override
  String? imageUrl;

  @override
  String? title;

  @override
  String ? type;

  @override
  String ?details;
  String ?place;
  String ?organizer;
  DateTime ? date;
  String ? time;
  bool ? favorite;
  Event({this.image, this.imageUrl, this.title, this.place, this.organizer,
       this.date,this.type,this.details,this.time,this.favorite});

  Event.fromJson(Map<String, dynamic> json) {
    organizer = json['organizer'];
    title = json['title'];
    imageUrl = json['imageUrl'];
    place = json['place'];
    date = json['date'].toDate();
    type = json['type'];
    details= json['details'];
   time= json['time'];
    favorite= json['favorite'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['organizer'] = organizer;
    data['title'] = title;
    data['imageUrl'] = imageUrl;
    data['place'] = place;
    data['date'] = date;
    data['type'] = type;
    data['details']=details;
    data['time']=time;
    data['favorite']=favorite;
    return data;
  }
}