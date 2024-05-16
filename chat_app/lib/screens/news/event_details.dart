import 'package:chat_app/models/news_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventDetails extends StatefulWidget {
  EventDetails({super.key, required this.event,required this.id});

  Event event;
  String? id ;
  @override
  State<EventDetails> createState() => _EventDetailsState();

}
class _EventDetailsState extends State<EventDetails> {
  bool  isFavourite =false;

  @override
  void initState() {
    super.initState();

      //getData();

  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize:MainAxisSize.max ,
            children: [
              Stack(
                children: [
                  SizedBox(
                      width: double.maxFinite,
                      height: 300,
                      child: Image.network(
                        widget.event.imageUrl!,
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
                            widget.event.title!,
                            style: const TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ],
              ),

               Padding(
                 padding: const EdgeInsets.all(20.0),
                 child: Text.rich(TextSpan(
                  text: "Organizer :               ",
                  style:   const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20),
                  children: [
                    TextSpan(text: widget.event.organizer,style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,fontWeight: FontWeight.w300,
                    )),
                  ],),),),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text.rich(TextSpan(
                  text: "Place :               ",
                  style:   const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20),
                  children: [
                    TextSpan(text: widget.event.place,style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,fontWeight: FontWeight.w300,
                    )),
                  ],),),),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text.rich(TextSpan(
                  text: "Date :               ",
                  style:   const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20),
                  children: [

                    TextSpan(text: widget.event.date?.toString().substring(0,10),
                        style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,fontWeight: FontWeight.w300,
                    )),
                    TextSpan(text:"  ${widget.event.time}",style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,fontWeight: FontWeight.w300,))
                  ],),),),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text.rich(TextSpan(
                  text: "Details  : \n",
                  style:   const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20),
                  children: [
                    TextSpan(text: widget.event.details,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,fontWeight: FontWeight.w300,
                        )),

                  ],),),),
              IconButton(
                onPressed: ()async{

                  await    addToFav();


                },
                icon: Icon( widget.event.favorite??false?Icons.favorite:Icons.favorite_border),
                alignment: Alignment.bottomLeft,
              ),
            ],
          ),
        ),
      ),
    );
  }
  /*getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavourite= prefs.getBool("calender ${widget.id!}") ??false;
    });
  }*/
/*
  setData(){
    setState(() {
      Future<SharedPreferences> prefs =  SharedPreferences.getInstance();
      prefs.then((value) { value.setBool("calender ${widget.id!}",!isFavourite );
      isFavourite= value.getBool("calender ${widget.id!}") ??false;
      });
    });

  }*/
  addToFav() async{
    setState(() {
      widget.event.favorite = !widget.event.favorite! ;
    });

    await  FirebaseFirestore.instance
        .collection("news").
    doc(widget.id).update(widget.event.toJson());

  }

}
