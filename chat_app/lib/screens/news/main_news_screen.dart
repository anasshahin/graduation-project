
import 'package:chat_app/models/news_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/advertisement_model.dart';
import '../../widgets/color_gradient.dart';
import '../book/advertisement_details.dart';
import '../calender.dart';
import '../search.dart';
import 'event_details.dart';
List<String> featureList = [
  "event",
  "news",

];

class MainNewsScreenView extends StatefulWidget {
   const MainNewsScreenView({super.key});

  @override
  State<MainNewsScreenView> createState() => _MainNewsScreenViewState();
}

class _MainNewsScreenViewState extends State<MainNewsScreenView> {
  String ? choose ;

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(

        body: Column(
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
                  child: const Text('News',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      )),
                //  IconButton(icon: const Icon(Icons.calendar_month,),onPressed: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const CalenderApp() )),)
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
                          MaterialPageRoute(builder: (_)=>const Search(type: 'event',)));},
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Search for news and events...",
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: featureList.map((college) {
                  return ElevatedButton(child: Text(college,), onPressed: () {
                    setState(() {
                      choose = college;

                    });
                  });
                }).toList(),
              ),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('news')
                    .snapshots(),
                builder: (context, snapshots) {
                  final listID= snapshots.data?.docs.map((e) => e.id).toList();
                  final loadedMessages = snapshots.data?.docs.where((element) =>
                  element.data()["type"] ==choose || choose == null)
                      .toList();
                  if (!snapshots.hasData || snapshots.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("No news is shared"),
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
                          itemBuilder: (context, e) {
                            return InkWell(
                                onTap: () {
                                  Advertisement  advertisement =Advertisement();
                                  Event events = Event();
                                  loadedMessages?[e].data()['type']=='news'?
                                  advertisement =
                                  Advertisement(details: loadedMessages?[e].data()['details'],
                                      name: loadedMessages?[e].data()['title'],
                                      imageUrl: loadedMessages?[e].data()['imageUrl']

                                  ):  events= Event.fromJson(loadedMessages![e].data());

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) {
                                        return loadedMessages?[e].data()['type']=="event"?
                                        EventDetails( event: events,id:listID?[e] ,):
                                        AdvertisementDetails(
                                          type: 'news',
                                          advertisement: advertisement,id: listID?[e],);

                                      }));
                                },
                                child: imageAndColor(
                                    Colors.white,
                                    loadedMessages?[e].data()['title'],
                                    loadedMessages?[e].data()['imageUrl']));
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
        ),
      ),
    );
    ;
  }
}
