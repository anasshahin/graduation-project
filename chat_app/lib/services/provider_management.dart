import 'dart:developer';

import 'package:chat_app/services/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/advertisement_model.dart';
import '../models/news_model.dart';

class AdvertisementProvider with ChangeNotifier{
  int selectedIndex =0;
  List<Advertisement>? advertisements;
  List< bool> ? favouriteValue =[false,false, false, false ];

  addAdvertisement(Advertisement advertisement) async{
  String? uuid=   const Uuid().v4();

    final Reference storageRef = FirebaseStorage.instance
        .ref()
        .child("user_images")
        .child("$uuid${advertisement.name}.jpg");
    await storageRef.putFile(advertisement.image!);
    final imageUrl = await storageRef.getDownloadURL();
    log(imageUrl);
    FirebaseFirestore.instance
        .collection("advertisements")
        .add({
      "book name":advertisement.name,
      "email":advertisement.email,
     "college":advertisement.college,
      "department":advertisement.department,
      "image_Url":imageUrl,
      "details":advertisement.details,
      "favorite":false
    });
  advertisement.imageUrl = imageUrl;
    advertisements?.add(advertisement);
  notifyListeners();
  }
  void viewer(int index){
      selectedIndex=index;
    notifyListeners();
  }
  bool?isFavBook(String id){
    return  SharedPrefHelper.getBooleanValue(id);
  }
  getData()  async {
    int c=0;
  final  loadedID=  FirebaseFirestore.instance
        .collection('advertisements')
        .snapshots()/*.map((event) => event.docs.map((e) => e.id).toList())*/;
    SharedPreferences prefs =  await SharedPreferences.getInstance() ;
  loadedID.listen((event) {
    event.docs.map((e) {
      favouriteValue?[c]= (prefs.getBool(e.id) ??false) ;
      c++;

    });

  });

  notifyListeners();

  }
}
