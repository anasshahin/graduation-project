import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
class CalenderAppUn extends StatefulWidget {
  const CalenderAppUn({super.key});

  @override
  State<CalenderAppUn> createState() => _CalenderAppUnState();
}

class _CalenderAppUnState extends State<CalenderAppUn> {
 List<bool>? fav;

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        child: Scaffold(
      appBar: AppBar(),
      body:StreamBuilder(
        stream:FirebaseFirestore.instance
            .collection('news')
            .snapshots(),
        builder:(ctx,snapshots){
          final listID= snapshots.data?.docs.where((element) =>
          element.data()["type"] =="event").map((e) => e.id).toList();
          final  loadedMessages = snapshots.data?.docs.where((element) =>
          element.data()["type"] =="event" &&element.data()["favorite"]==true )
              .toList();
          if (!snapshots.hasData || snapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text("No news is shared"),
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
        return  SfCalendar(
            view: CalendarView.week,
            firstDayOfWeek: 6,
            dataSource: MeetingDataSource(getAppointments( loadedMessages,listID)),

          );
        }
      ) ,

    ));
  }

  /*getData(String id)  async {
    SharedPreferences prefs =  await SharedPreferences.getInstance() ;
    setState(() {
      fav?.add( prefs.getBool("calender $id") ??false);

    });

  }*/
  List<Appointment> getAppointments(List<QueryDocumentSnapshot<Map<String, dynamic>>>? loadedMessages,loadedID) {
    List<Appointment> meetings = <Appointment>[];
    for( int i =0;i<loadedMessages!.length;i++){
     // log(loadedID[i]);
      //getData(loadedID[i]);
      DateTime dateTime =   loadedMessages[i].data()['date'].toDate() ;
      List<String> time= loadedMessages[i].data()['time'].split(":");
      final DateTime startTime =
      DateTime (dateTime.year,
          dateTime.month,dateTime.day,
          int.parse(time[0]),int .parse(time[1][0]+time[1][1]) );
      final DateTime endTime = startTime.add(
          const Duration (hours: 2));
        meetings.add(Appointment(
        startTime: startTime,
        endTime: endTime,
        subject: 'Conference',
        color: Colors.green.shade900,
      ));
    }


    return meetings;
  }

}

class MeetingDataSource extends CalendarDataSource{
  MeetingDataSource(List<Appointment> source){
    appointments=source;
  }
}
