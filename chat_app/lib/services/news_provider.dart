import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/news_model.dart';

class NewsProvider with ChangeNotifier{
  int statusCode = 0;
  String msg = '';
  List<Book>? listNews;
  addNews(Book news) async{
    String? uuid=   const Uuid().v4();

    final Reference storageRef = FirebaseStorage.instance
        .ref()
        .child("user_images")
        .child("$uuid${news.title}.jpg");
    await storageRef.putFile(news.image!);
    final imageUrl = await storageRef.getDownloadURL();
    log(imageUrl);
    news.imageUrl=imageUrl;

    FirebaseFirestore.instance
        .collection("news")
        .add(news.toJson())
        .whenComplete(() {
      log('post data added successful');
      statusCode = 200;
      msg = 'post data added successful';

    }).catchError((error) {
      handleAuthErrors(error);
      log('statusCode : $statusCode , error msg : $msg');
    });
    news.imageUrl = imageUrl;
    listNews?.add(news);
    notifyListeners();
  }
  void handleAuthErrors(ArgumentError error) {
    String errorCode = error.message;
    switch (errorCode) {
      case "ABORTED":
        {
          statusCode = 400;
          msg = "The operation was aborted";
        }
        break;
      case "ALREADY_EXISTS":
        {
          statusCode = 400;
          msg = "Some document that we attempted to create already exists.";
        }
        break;
      case "CANCELLED":
        {
          statusCode = 400;
          msg = "The operation was cancelled";
        }
        break;
      case "DATA_LOSS":
        {
          statusCode = 400;
          msg = "Unrecoverable data loss or corruption.";
        }
        break;
      case "PERMISSION_DENIED":
        {
          statusCode = 400;
          msg =
          "The caller does not have permission to execute the specified operation.";
        }
        break;
      default:
        {
          statusCode = 400;
          msg = error.message;
        }
        break;
    }
  }

}
