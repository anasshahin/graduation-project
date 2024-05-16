import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/advertisement_model.dart';
import '../models/news_model.dart';
import '../services/lists.dart';
import '../widgets/color_gradient.dart';
import 'book/advertisement_details.dart';
import 'news/event_details.dart';

class Search extends StatefulWidget {
   const Search({super.key,required this.type});
final String type;
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String targetCollege = "college";

  String targetDepartment = "department";

  String? choosesDepartment;

  String? choosesCollege;

  List<QueryDocumentSnapshot<Map<String, dynamic>>>? loadedMessages;


  String enteredKey = "";

  void _runFilter(String enterKey) {
    setState(() {
      enteredKey = enterKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(

          backgroundColor: Colors.green.shade900,
          shadowColor:Colors.black12 ,

          centerTitle: true,
          title: Text(widget.type=='book'?"search for your book ":"search news and events",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white)),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 30, bottom: 15, left: 15, right: 15),
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.30),
                        offset: const Offset(0, 5),
                        blurRadius: 5)
                  ]),
                  child: TextField(
                    onChanged: (value) => _runFilter(value),
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText:widget.type=='book'? "Search your book...":"Search for news and events...",
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade400,
                        )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ExpansionTile(
                  title: Text(targetCollege),
                  backgroundColor: Colors.grey,
                  children: listCollege.map((college) {
                    return TextButton(
                        child: Text(college),
                        onPressed: () {
                          setState(() {
                            targetCollege = college;
                            choosesCollege = college;
                          });
                        });
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if(targetCollege != 'college')
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: const BoxDecoration(),

                  child: ExpansionTile(
                    title: Text(targetDepartment),
                    backgroundColor: Colors.grey,
                    children: listDepartment[targetCollege]!.map((department) {
                      return TextButton(
                          style: ButtonStyle(
                              side: MaterialStateProperty.all(
                                  const BorderSide(color: Colors.black))),
                          child: Text(department),
                          onPressed: () {
                            setState(() {
                              targetDepartment = department;
                              choosesDepartment = department;
                            });
                          });
                    }).toList(),
                  ),
                ),
              ),
              StreamBuilder(

                stream: FirebaseFirestore.instance
                    .collection(widget.type=='book'?'advertisements':'news')
                    .snapshots(),
                builder:(context, snapshots) {
                  final listID= snapshots.data?.docs.map((e) => e.id).toList();

                  loadedMessages = snapshots.data?.docs
                      .where((element) =>
                  (element.data()["college"] == choosesCollege &&
                      element.data()["department"] ==
                          choosesDepartment) ||
                      choosesDepartment == null && choosesCollege == null)
                      .toList();
                  if (!snapshots.hasData || snapshots.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("No messages send"),
                    );
                  }
          
                  if (snapshots.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshots.hasError) {
                    return const Center(
                      child: Text('Something went wrong'),
                    );
                  }
                   return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,),
                      child: GridView.builder(

                        shrinkWrap: true,
                      //  scrollDirection: Axis.,
                        itemBuilder: (context, index) {
                          if (enteredKey.isEmpty) {
                            return InkWell(
                              onTap: () {
                                if(widget.type=='book'){
                                  openBook(index, context, listID);
                                }else{
                                  Advertisement  advertisement =Advertisement();
                                  Event events = Event();
                                  loadedMessages?[index].data()['type']=='news'?
                                  advertisement =
                                      Advertisement(details: loadedMessages?[index].data()['details'],
                                          name: loadedMessages?[index].data()['title'],
                                          imageUrl: loadedMessages?[index].data()['imageUrl']

                                      ):  events= Event.fromJson(loadedMessages![index].data());

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) {
                                        return loadedMessages?[index].data()['type']=="event"?
                                        EventDetails( event: events,id:listID?[index] ,):
                                        AdvertisementDetails(
                                          type: 'news',
                                          advertisement: advertisement,id: listID?[index],);

                                      }));
                                }

                              },
                              child: imageAndColor(
                                  Colors.white,
                                  loadedMessages?[index]
                                      .data()[widget.type=='book'?'book name':'title'],
                                  loadedMessages?[index]
                                      .data()[widget.type=='book'?'image_Url':'imageUrl']));
                          }else if (loadedMessages![index].data()[widget.type=='book'?'book name':'title']
                              .toString()
                              .toLowerCase()
                              .startsWith(enteredKey.toLowerCase())){
                            return InkWell(
                                onTap: () {
                                  Advertisement  advertisement =Advertisement();
                                  if(widget.type=='book'){
                                    openBook(index, context, listID);
                                  }
                                  else{
                                    Event events = Event();
                                    loadedMessages?[index].data()['type']=='news'?
                                    advertisement =
                                        Advertisement(details: loadedMessages?[index].data()['details'],
                                            name: loadedMessages?[index].data()['title'],
                                            imageUrl: loadedMessages?[index].data()['imageUrl']

                                        ):  events= Event.fromJson(loadedMessages![index].data());
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (_) {
                                          return loadedMessages?[index].data()['type']=="event"?
                                          EventDetails( event: events,id:listID?[index] ,):
                                          AdvertisementDetails(
                                            type: 'news',
                                            advertisement: advertisement,id: listID?[index],);

                                        }));
                                  }

                                },
                                child: imageAndColor(
                                    Colors.white,
                                    loadedMessages?[index]
                                        .data()[widget.type=='book'?'book name':'title'],
                                    loadedMessages?[index]
                                        .data()[widget.type=='book'?'image_Url':'imageUrl']));
                          }
                          else{
                            return const SizedBox(width: 5,height: 5,);
                          }

                        },
                        itemCount: loadedMessages?.length,
                        gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 250,
                                childAspectRatio: 1,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 20)

                      ),
                    );
                  }
                  )
            ],
          ),
        ),
      ),
    );
  }

  void openBook(int index, BuildContext context, List<String>? listID) {
    Advertisement advertisement1 = Advertisement(
      department: loadedMessages?[index].data()['department'],
      college:loadedMessages?[index].data()['college'] ,
      name:  loadedMessages?[index].data()['book name'],

      email:  loadedMessages?[index].data()['email'],
      details:  loadedMessages?[index].data()['details'],
      favorite: loadedMessages?[index].data()['favorite'],
    );
    advertisement1.imageUrl = loadedMessages?[index]
        .data()['image_Url'];
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) {
          return AdvertisementDetails(
            type: "advertisement",
            id:listID?[index] ,
            advertisement: advertisement1,);
        }));
  }
}
