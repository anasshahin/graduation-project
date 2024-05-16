
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/advertisement_model.dart';
import '../../services/provider_management.dart';
import 'advertisement_details.dart';

class Advertisements extends StatefulWidget {
   Advertisements({super.key,this.favourite});
  bool ? favourite =false;

  @override
  State<Advertisements> createState() => _AdvertisementsState();
}

class _AdvertisementsState extends State<Advertisements> {

  @override
  void initState() {

    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title:  Text(!(widget.favourite??false)?'Your Advertisements':'Your favorite'), centerTitle: true),
      body: StreamBuilder(

          stream: FirebaseFirestore.instance
              .collection('advertisements')
              .snapshots(),
          builder: (context, snapshots) {
            final  listID= snapshots.data?.docs.map((e) => e.id).toList();
            final loadedMessages =widget.favourite!? snapshots.data?.docs
                .toList():snapshots.data?.docs
                .where((element) =>
                    element.data()["email"] ==
                    FirebaseAuth.instance.currentUser?.email)
                .toList();
            if (!snapshots.hasData || snapshots.data!.docs.isEmpty) {
              return const Center(
                child: Text("No messages send"),
              );
            }

           /* if (snapshots.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }*/
            if (snapshots.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }
            return ListView.builder(

                itemCount: loadedMessages?.length,

                itemBuilder: (ctx, index) {
              //    getData(loadedID![index]);
                  if (widget.favourite! ==true &&loadedMessages?[index].data()['favorite']) {
                    return favList(loadedMessages, index, context,listID);
                  }
                  else if(widget.favourite! ==false) {
                    return favList(loadedMessages, index, context,listID);
                  }
                  return const SizedBox();

                 /* Provider.of<AdvertisementProvider>(context, listen: true)
                      .getData();
                  if(Provider.of<AdvertisementProvider>(context, listen: false)
                      .favouriteValue![index]) {
                    return favList(loadedMessages, index, context);
                  }*/
                });
          }),

    );
  }

  InkWell favList(List<QueryDocumentSnapshot<Map<String, dynamic>>>? loadedMessages,
      int index, BuildContext context,List<String>? listID) {
    return InkWell(
                  onTap: (){
                    Advertisement advertisement=Advertisement(
                    name:   loadedMessages?[index].data()['book name'],
                     email:   loadedMessages?[index].data()['email'],
                      details:   loadedMessages?[index].data()['details'],
                      favorite: loadedMessages?[index].data()['favorite'],
                      college: loadedMessages?[index].data()['college'],
                      department: loadedMessages?[index].data()['department'],
                    );
                    advertisement.imageUrl=loadedMessages?[index].data()['image_Url'];
                    Navigator.of(context).push(MaterialPageRoute(builder: (_){
                      return   AdvertisementDetails( advertisement: advertisement,
                        id: listID?[index],
                        type: "advertisement",);
                    }));

                  },
                  child: Card(
                      color: Colors.blueGrey,
                      shadowColor: Colors.grey,
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                         padding: const EdgeInsets.symmetric(vertical: 15),
                          child: ListTile(
                            title: Text(
                                loadedMessages?[index].data()["book name"],
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            leading: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  loadedMessages?[index].data()['image_Url'],

                                )),
                          ),
                        ),
                      )),
                );
  }

  /* getData(String id)  async {
   SharedPreferences prefs =  await SharedPreferences.getInstance() ;
setState(() {
  fav.add(prefs.getBool(id) ?? false) ;
});

   }*/
}
