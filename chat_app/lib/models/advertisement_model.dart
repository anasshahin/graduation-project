import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';


class Advertisement{
   String? name;
   String ?imageUrl;
   File? image;
   String? department;
   String ?details;
   String ?college;
   String ?email;
   Timestamp ?date;
   String ?place;
   String ?organizer;
   String ?time;
   bool ? favorite;
   Advertisement({
      this.name,
      this.imageUrl,
      this.image,
      this.department,
      this.details,
      this.college,
      this.email,
      this.date,
      this.place,
      this.organizer,
      this.time,
      this.favorite,
   });
   Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['book name'] = name;
      data['email'] = email;
      data['image_Url'] = imageUrl;
      data['department'] = department;
      data['college'] = college;
      data['favorite'] = favorite;
      data['details'] = details;

      return data;
   }

}
