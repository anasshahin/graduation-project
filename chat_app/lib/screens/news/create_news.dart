import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../models/advertisement_model.dart';
import '../../models/news_model.dart';
import '../../services/news_provider.dart';
import '../../services/provider_management.dart';
import '../../widgets/user_image.dart';

class CreateNewsAdvertisement extends StatefulWidget {
   const CreateNewsAdvertisement({super.key,required this.type});
 final String type ;
  @override
  State<CreateNewsAdvertisement> createState() => _CreateNewsAdvertisementState();
}

class _CreateNewsAdvertisementState extends State<CreateNewsAdvertisement> {
  final List<String> listCollege = [
    "Engineer",
    "Science",
    "Literature",
    "Arts",
    "Islamic Law",
    "Medicine",
    "Media",
    "Economy",
    "Education",
    "Tourism",
    "Archaeology",
    "Sports",
    "Low",
    "IT",
  ];

  final _formKey = GlobalKey<FormState>();
  TimeOfDay _timeOfDay = const TimeOfDay (hour: 8, minute: 30);
  String _timeDay = "";

  final TextEditingController newsTitle = TextEditingController();
  final TextEditingController newsDetails = TextEditingController();
  final TextEditingController eventPlace = TextEditingController();
  final TextEditingController eventOrganisers = TextEditingController();
  String targetCollege = "college";

  String targetDepartment = "department";
  DateTime _dateTime = DateTime.now();
  File? _selectedImage;
  void _showDatePicker(){
    showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000), 
        lastDate:DateTime(2030) ).then((value) {
         setState(() {
           _dateTime = value!;
         });
        });
  }
  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      setState(() {

        _timeOfDay = value!;

        _timeDay=_timeOfDay.format(context);
       // _dateTime.copyWith(hour:_timeOfDay.hour,minute: _timeOfDay.minute );
        log(_dateTime.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:  Text("Add University ${widget.type}",
              style: const TextStyle(color: Colors.white)),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20))),
          backgroundColor: Colors.green.shade900),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                 Text(
                  "${widget.type} title",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: newsTitle,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Type your news title ...",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      prefixIcon: Icon(
                        Icons.title,
                        color: Colors.grey.shade400,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),

                 const Text(
                  "news details",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20),
                ),

                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: newsDetails ,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText:widget.type=="news"? "Type your news details ...":"Type your place event ...",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      prefixIcon: Icon(
                        Icons.drive_file_rename_outline,
                        color: Colors.grey.shade400,
                      )),
                ),
                const Text(
                  "event place",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20),
                ),

                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: eventPlace,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText:widget.type=="news"? "Type your news details ...":"Type your place event ...",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      prefixIcon: Icon(
                        Icons.drive_file_rename_outline,
                        color: Colors.grey.shade400,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),


                if(widget.type=="event")

                  const Text(
                    "Organisers name",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20),
                ),
                if(widget.type=="event")

                  const SizedBox(
                  height: 10,
                ),
                if(widget.type=="event")

                  TextFormField(
                  controller: eventOrganisers,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "name of Organizer like : FACULTY OF SCIENCE ...",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      prefixIcon: Icon(
                        Icons.title,
                        color: Colors.grey.shade400,
                      )),
                ),
                if(widget.type=="event")

                  const SizedBox(
                    height: 10,
                  ),
                if(widget.type=="event")
                  const Text(
                    "Date of staring the event",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                  ),
                if(widget.type=="event")

                  const SizedBox(
                    height: 10,
                  ),
                if(widget.type=="event")
                ElevatedButton(
                  onPressed: _showDatePicker,

                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 20))),
                  child: const Text("click here to insert date"),
                ),
                if(widget.type=="event")

                  const SizedBox(
                    height: 10,
                  ),
                if(widget.type=="event")
                  ElevatedButton(
                    onPressed: _showTimePicker,
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(vertical: 20))),
                    child: const Text("click here to insert time"),
                  ),
                if (widget.type=="news")
                  ExpansionTile(
                  title:  Text(targetCollege),
                  backgroundColor: Colors.grey,
                  children: listCollege.map((college) {
                    return TextButton(
                        child: Text(college),
                        onPressed: () {
                          setState(() {
                            targetCollege = college;
                          });

                        });
                  }).toList(),
                ),
                if(widget.type=="news")

                  const SizedBox(
                  height: 10,
                ),
                if(widget.type=="news")

                  ExpansionTile(
                  title:  Text(targetDepartment),
                  backgroundColor: Colors.grey,
                  children: listCollege.map((department) {
                    return TextButton(
                        child: Text(department),
                        onPressed: () {
                         setState(() {
                           targetDepartment = department;
                         });
                        });
                  }).toList(),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Choose image for your news ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: UserImage(onPickImage: (File pickedImage) {
                    _selectedImage = pickedImage;
                  }),
                ),
                ElevatedButton(
                  onPressed: () {
                    Book ? newsModel;
                    if (widget.type=="news") {
                      newsModel  =News(title: newsTitle.text,image: _selectedImage,college: targetCollege,
                        department: targetDepartment,details: newsDetails.text,type: "news"
                    );
                    }
                    else if (widget.type=="event"){
                      log(_dateTime.toString() );log(eventOrganisers.text );log(eventPlace.text );log(_timeOfDay.toString() );
                      log(newsTitle.text );log(newsDetails.text );
                      newsModel  =Event(title:  newsTitle.text,image: _selectedImage,date: _dateTime,
                         organizer: eventOrganisers.text,place: eventPlace.text,time: _timeDay,details:newsDetails.text,type: "event",
                      );
                    }
                    Provider.of<NewsProvider>(context, listen: false)
                        .addNews(newsModel!);
                    setState(() {
                      newsTitle.text="";
                      targetCollege = "college";
                      targetDepartment = "department";
                      newsDetails.text ="";
                      pickedImageFile=null;
                    });

                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 20))),
                  child: const Text("Submit"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
