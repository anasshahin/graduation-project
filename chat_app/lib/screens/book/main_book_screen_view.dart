import 'dart:io';

import 'package:chat_app/services/provider_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/advertisement_model.dart';
import '../../services/lists.dart';
import '../../widgets/color_gradient.dart';
import '../search.dart';
import 'advertisement_details.dart';

class MainBookScreenView extends StatefulWidget {
  const MainBookScreenView({super.key});

  @override
  State<MainBookScreenView> createState() => _MainBookScreenViewState();
}

class _MainBookScreenViewState extends State<MainBookScreenView> {
  String ? choose ;

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [

            Container(
              height: 200,
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: const Color(0xff0F2310),
                gradient: LinearGradient(
                  colors: [
                    Colors.green.shade900.withOpacity(0.7),
                    const Color(0xff0F2310)
                  ],
                  end: Alignment.topLeft,
                  begin: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.only(top: 70, left: 15),
              child: const Text('Here is the library part',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  )),
            ),
            Padding(padding: const EdgeInsets.only(top: 10, left: 10),
              child: IconButton(onPressed: () {
                Navigator.of(context).pop();
              },
                  icon: const Icon(Icons.arrow_circle_left,size: 30,
                    color: Colors.black,

                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 170, left: 20, right: 20),
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.30),
                      offset: const Offset(0, 5),
                      blurRadius: 5)
                ]),
                child: TextField(
                  onTap: (){Navigator.of(context).push(
                      MaterialPageRoute(builder: (_)=>const Search(type: 'book',)));},
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Search your book...",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade400,
                      )),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          flex: 1,
          child: ListView(

            scrollDirection: Axis.horizontal,
            reverse: true,
            shrinkWrap: true,
            children: listCollege.map((college) {
              return TextButton(child: Text(college), onPressed: () {
                setState(() {
                  choose = college;

                });
              });
            }).toList(),
          ),
        ),
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('advertisements')
                .snapshots(),
            builder: (context, snapshots) {
             final listID= snapshots.data?.docs.map((e) => e.id).toList();
              final loadedMessages = snapshots.data?.docs.where((element) =>

              element.data()["college"] ==choose || choose == null)
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
              return Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {

                          return  InkWell(
                            onTap: () {
                              Advertisement advertisement = Advertisement(
                                college: loadedMessages?[index].data()['college'],
                               department: loadedMessages?[index].data()['department'],
                               name:  loadedMessages?[index].data()['book name'],

                               email:  loadedMessages?[index].data()['email'],
                               details:  loadedMessages?[index].data()['details'],
                                favorite: loadedMessages?[index].data()['favorite'],
                              );
                              advertisement.imageUrl = loadedMessages?[index]
                                  .data()['image_Url'];

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) {
                                    return AdvertisementDetails(
                                      type: "advertisement",
                                      id:listID?[index] ,
                                      advertisement: advertisement,);
                                  }));
                            },
                            child: imageAndColor(
                                Colors.white,
                                loadedMessages?[index].data()['book name'],
                                loadedMessages?[index].data()['image_Url'])

                        );


                      },
                      itemCount: loadedMessages?.length,
                      gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 250,
                          childAspectRatio: 1,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20),
                    ),
                  ));
            })
      ],
    );
    ;
  }
}

/*
 imageAndColor(Colors.white,"calculus","https://m.media-amazon.com/images/I/61RLFiGj7UL._AC_UF1000,1000_QL80_.jpg"),
                    imageAndColor(Colors.white,"c++","https://m.media-amazon.com/images/I/41APdAQ2kwL._AC_UF894,1000_QL80_.jpg"),
                    imageAndColor(Colors.white,"data structure and algorithm","https://pragprog.com/titles/jwdsal2/a-common-sense-guide-to-data-structures-and-algorithms-second-edition/jwdsal2.jpg"),
                    imageAndColor(Colors.white,"asp.net","https://m.media-amazon.com/images/I/61JDpjYsl2L._AC_UF1000,1000_QL80_.jpg"),*/
