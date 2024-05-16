import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chat_app/models/news_model.dart';
import 'package:chat_app/screens/book/advertisement_details.dart';
import 'package:chat_app/screens/book/main_book.dart';
import 'package:chat_app/screens/calender.dart';
import 'package:chat_app/screens/news/event_details.dart';
import 'package:chat_app/screens/news/main_news_screen.dart';
import 'package:chat_app/screens/news/news&events.dart';
import 'package:chat_app/map/university_map.dart';
import 'package:chat_app/screens/users_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/advertisement_model.dart';
class MainScreenApp extends StatefulWidget {
   const MainScreenApp({super.key});

  @override
  State<MainScreenApp> createState() => _MainScreenAppState();
}

class _MainScreenAppState extends State<MainScreenApp> {
  int count =0;
  int currentState=0;
List features1 =[
  {
    "image":"assets/images/img_ellipse_24.png",
    "name":"News",
    "feature":const MainNewsScreenView(),
  },
  {
    "image":"assets/images/img_ellipse_23.png",
    "name":"Map",
  "feature":  PluginZoomButtons(),

  },
  {
    "image":"assets/images/img_ellipse_22.png",
    "name":"Book swap",
  "feature":const MainBooksScreen(),

  },
  {
    "image":"assets/images/img_ellipse_22.png",
    "name":"create news",
    "feature":const EventsNews(),

  },

];
List features2 =[
     {

       "image": "assets/images/img_ellipse_19.png",
       "name":"Sis",
       "link":"https://sis.yu.edu.jo/ords/r/sis/sis/login"
     },
     {
       "image":"assets/images/img_ellipse_20.png",
       "name":"E_learning",
       "link":"https://elearning.yu.edu.jo/first2023/login/index.php",
     },

   ];
List<String> imageList = [
  'assets/images/img_ellipse_23.png',
  'assets/images/img_ellipse_24.png',
  'assets/images/img_ellipse_20.png',
];
  List<int> imageList1 =[0,1,2];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState> ();
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Yarmouk campus"),
          centerTitle:true ,
        ),
        drawer: Drawer(

          child: ListView(
           // shrinkWrap: true,
            children: [
              const DrawerHeader(child: SizedBox(height: 100,
                child: Center(child: Text('Alyarmouk application',style: TextStyle(
                    fontSize: 30,fontWeight: FontWeight.bold),)),)),

              ListTile(
                onTap: (){
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop();
                },
                title: const Text('Log out',
                  style: TextStyle(fontSize: 30,/*fontFamily: 'Julee Regular'*/),),
                subtitle: const Text('log out to sign with other account', // title equal to child
                ),
                trailing: const Icon(Icons.logout_outlined),

              ),
              const Divider(),
              ListTile(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=>
                  const CalenderAppUn()
                  ));
                },
                title: const Text('Your calender',
                  style: TextStyle(fontSize: 30,/*fontFamily: 'Julee Regular'*/),),
                subtitle: const Text('indicate all the event that you want to see', // title equal to child
                ),
                trailing: const Icon(Icons.calendar_month),

              ),
              const Divider(),

            ],

          ),
        ),
        body: Column(
        children: [
          Stack(
            children: [

              Container(
                alignment: Alignment.center,
                height: 250,
                width: double.maxFinite,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: Color(0xff0F2310),

                ),
                padding: const EdgeInsets.all(40),
                child:
                 SvgPicture.asset(
                  'assets/images/img_group.svg',
                  height: 150.0,
                 // width: 20.0,
                  allowDrawingOutsideViewBox: true,
                ),
              ),

            ],
          ),
          Expanded(
            flex: 3,
            child: ListView(

              scrollDirection: Axis.horizontal,
              children: features1.map((e) => appFeature(e['image'],e['name'],() {
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=> e["feature"],
                )
                );},)).toList()
            ,),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: features2.map((e) => appFeature(e['image'],e['name'],() async {
                var url = Uri.parse(e['link']);
                await canLaunchUrl(url)?
                throw 'the link is not work':await launchUrl(url,
                  mode: LaunchMode.externalApplication,);
              })).toList()
              ,),
          ),
          Expanded(
            flex:4,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: newsSlider(),
            ),
          )
        ],
                  ),
      ),
    );

  }

  Widget appFeature(String image,String nameFeature,VoidCallback function) {
    return InkWell(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
//padding: const EdgeInsets.all(10.0),
                  height: 128,
                  width: 128,
                  decoration: BoxDecoration(

                      color: const Color(0xff0F2310),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Column(
                    children: [
                      Image.asset(image,height: 83,width: 83),
                       Text(nameFeature,style:const TextStyle(color: Colors.white),)
                    ],
                  ),

                ),
      ),
    );
  }

  StreamBuilder newsSlider() {
     return StreamBuilder(
         stream: FirebaseFirestore.instance
             .collection('news')
             .snapshots(),
       builder: (context, snapshots) {
         final loadedMessages = snapshots.data?.docs;
         final listID= snapshots.data?.docs.map((e) => e.id).toList();
         if (!snapshots.hasData || snapshots.data!.docs.isEmpty) {
           return const Center(
             child: Text("No news is shared"),
           );
         }
/*
        if (snapshots.connectionState == ConnectionState.waiting) {
           return const Center(
             child: CircularProgressIndicator(),
           );
         }*/
         if (snapshots.hasError) {
           return const Center(
             child: Text('Something went wrong'),
           );
         }


         return CarouselSlider(
           options:CarouselOptions(height: 170,
               initialPage: 1,// select the pic that will appear in the first
               enlargeCenterPage: true,
               autoPlay: true , // make CarouselSlider auto move
               autoPlayInterval:const Duration(seconds: 6),
               reverse: true, // change the direction of move scroll
               enableInfiniteScroll: false , // we receive to the final item it return back
               pauseAutoPlayOnTouch: false, // if true it stop scroll when user touch the item
               onPageChanged: (int index , _){
                 setState(() {
                   currentState= index;

                 });
               }
           ),
           items: imageList1.map((e)
           {return InkWell(
             onTap: (){
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
                       advertisement: advertisement,);

                   }));
             },
             child: SizedBox(width: double.infinity,
               child: Image.network(loadedMessages?[e].data()['imageUrl'],),
             ),
           );}).toList(),
         );
       }

     );
   }
}
class ImageSliderWidget extends StatefulWidget {
  const ImageSliderWidget({Key? key}) : super(key: key);

  @override
  State<ImageSliderWidget> createState() => _ImageSliderWidgetState();
}

class _ImageSliderWidgetState extends State<ImageSliderWidget> {
  List<String> imageList = [
    'assets/images/chess/chess_n.jpg',
    'assets/images/chess/chess_game_pic.jpg',
    'assets/images/chess/chess_king.jpg',
  ];
  int currentState=0;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(
        centerTitle: true,
      ) ,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            newsSlider(),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [buildContainer(2),
                buildContainer(1),
                buildContainer(0),],),

            CarouselSlider.builder(
                itemCount: imageList.length,

                itemBuilder: (/*BuildContext ctx*/_,int index , int realIndex){
                  return Container(width: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Image.asset(imageList[index],fit: BoxFit.fill),
                  );
                },
                options:CarouselOptions(
                  scrollDirection: Axis.vertical,
                  height: 250,
                  initialPage: 0,
                  enlargeCenterPage: true,
                )
            )
          ],
        ),
      ),
    );
  }

  CarouselSlider newsSlider() {
    return CarouselSlider(
            options:CarouselOptions(height: 170,
                initialPage: 1,// select the pic that will appear in the first
                enlargeCenterPage: true,
                autoPlay: true , // make CarouselSlider auto move
                autoPlayInterval:const Duration(seconds: 6),
                reverse: true, // change the direction of move scroll
                enableInfiniteScroll: false , // we receive to the final item it return back
                pauseAutoPlayOnTouch: false, // if true it stop scroll when user touch the item
                onPageChanged: (int index , _){
                  setState(() {
                    currentState= index;

                  });
                }
            ),
            items: imageList.map((image)
            {return SizedBox(width: double.infinity,
              child: Image.asset(image,fit: BoxFit.fill),
            );}).toList(),
          );
  }

  Container buildContainer(int index) {
    return Container(
      width: 10,
      height: 10,
      margin:const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(color:currentState==index? Colors.red:Colors.green,
          shape: BoxShape.circle),
    );
  }
}
