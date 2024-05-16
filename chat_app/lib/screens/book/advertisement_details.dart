import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/advertisement_model.dart';
import '../chat.dart';

class AdvertisementDetails extends StatefulWidget {
  AdvertisementDetails(
      {super.key, required this.advertisement, required this.type, this.id});

  Advertisement advertisement;

  String type;

  String? id;

  @override
  State<AdvertisementDetails> createState() => _AdvertisementDetailsState();
}

class _AdvertisementDetailsState extends State<AdvertisementDetails> {
  bool ? isFavourite = false;
  List<String?> connectedPeople=[];

  @override
  void initState() {
  super.initState();
  if(widget.type=="advertisement") {
    //getData();
  }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (ctx, snapshots){
              final listID= snapshots.data?.docs.where((element) =>
              element.data()["email"] ==FirebaseAuth.instance.currentUser?.email).map((e) => e.id).toList();
              final loadedMessages = snapshots.data?.docs.where((element) =>
              element.data()["email"] ==FirebaseAuth.instance.currentUser?.email)
                  .toList();
              /*
              final listID= snapshots.data?.docs.where((element) =>

              element.data()["email"] ==widget.advertisement.email).map((e) => e.id).toList();

              final loadedMessages = snapshots.data?.docs.where((element) =>

              element.data()["email"] ==widget.advertisement.email)
                  .toList();*/
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                          width: double.maxFinite,
                          height: 300,
                          child: Image.network(
                            widget.advertisement.imageUrl!,
                            fit: BoxFit.contain,
                          )),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.arrow_circle_left,
                            )),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 270, left: 20, right: 20),
                        child: Container(
                          height: 70,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: const Color(0xffF5F5f5).withOpacity(0.5),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(.30),
                                    offset: const Offset(0, 5),
                                    blurRadius: 5)
                              ]),
                          child: Center(
                              child: Text(
                                widget.advertisement.name!,
                                style: const TextStyle(fontSize: 20),
                              )),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(widget.advertisement.name!),
                  ),
                  Text.rich(TextSpan(
                    text: widget.advertisement.details,
                    style:   const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                  )),
                  if(widget.type == "advertisement" )
                    IconButton(
                      onPressed: ()async{

                        await    addToFav();


                      },
                      icon: Icon( widget.advertisement.favorite??false?Icons.favorite:Icons.favorite_border),
                      alignment: Alignment.bottomLeft,
                    ),

                  if (FirebaseAuth.instance.currentUser?.email !=
                      widget.advertisement.email &&
                      widget.type == "advertisement")
                    ElevatedButton(
                        onPressed: () async{
                          List<dynamic> addEmail= loadedMessages?[0].data()['connectedPeople'];
                         print(await FirebaseAuth.instance.currentUser?.email.toString());
                          log(listID![0]);

                          if(!loadedMessages?[0].data()['connectedPeople'].contains(widget.advertisement.email)) {
                            log('start');
                            addEmail.add(widget.advertisement.email);
                            print(loadedMessages?[0].data()['connectedPeople']);
                            await FirebaseFirestore.instance
                                .collection("users").
                            doc(listID[0]).update({
                              "username":loadedMessages?[0].data()['username'],
                              "email":loadedMessages?[0].data()['email'],
                              "image_url":loadedMessages?[0].data()['image_url'],
                              "connectedPeople":addEmail,

                            });

                          }

                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) {
                            return ChatScreen(
                              emailReceiver: widget.advertisement.email!,
                            );
                          }));

                        },
                        child: const Text('Chat with owner'))
                ]);},
          ),
        ),
        floatingActionButton:
        FirebaseAuth.instance.currentUser?.email ==
            widget.advertisement.email && widget.type == "advertisement"? FloatingActionButton(
          tooltip: "remove",

          onPressed: () async {
            await FirebaseFirestore.instance
                .collection("advertisements")
                .doc(widget.id)
                .delete()
                .whenComplete(() {
              log('post data deleted successful');
              Navigator.of(context).pop();
              //  statusCode = 200;
              //   msg = 'post data deleted successful';
            }).catchError((error) {
              //   handleAuthErrors(error);
              //   log('statusCode : $statusCode , error msg : $msg');
            });
          },
          child:  const Icon(Icons.remove_circle),

        ):null,

      ),
    );
  }
 /*getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavourite= prefs.getBool(widget.id!) ??false;
    });
  }*/
 /* setData(){
    setState(() {
      Future<SharedPreferences> prefs =  SharedPreferences.getInstance();
      prefs.then((value) { value.setBool(widget.id!,!isFavourite! );
      isFavourite= value.getBool(widget.id!) ??false;
      });
    });


  }*/
  addToFav() async{
    setState(() {
      widget.advertisement.favorite = !widget.advertisement.favorite! ;

    });

  await  FirebaseFirestore.instance
        .collection("advertisements").
    doc(widget.id).update(widget.advertisement.toJson());

  }

}
