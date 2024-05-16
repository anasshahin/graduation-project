import 'package:flutter/material.dart';

import 'create_news.dart';
class EventsNews extends StatelessWidget {
  const EventsNews({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Event and News'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          uiCreator(context,const CreateNewsAdvertisement(type: "news",),"Add news"),
          uiCreator(context,const CreateNewsAdvertisement(type: "event",),"Add events"),

        ],
      ),
    );
  }

  Center uiCreator(BuildContext context,Widget widget,String nameUi) {
    return Center(
      child: Material(

            elevation: 10,
            borderRadius:BorderRadius.circular(28) ,
            color: Colors.green.shade900,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_){
                  return  widget;
                }));
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Ink.image(
                    image: const AssetImage(
                      'assets/images/img_ellipse_24.png',
                    ),
                    fit: BoxFit.cover,
                    width: 250,
                    height: 250,
                  ),
                  const SizedBox(height: 6,),
                    Text(nameUi,style: const TextStyle(
                    fontSize: 32,color: Colors.white,fontWeight: FontWeight.bold,
                  )),
                ],
              ),
            ),

         ),
    );
  }
}
