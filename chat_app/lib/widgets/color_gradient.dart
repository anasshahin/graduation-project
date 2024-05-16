import 'package:flutter/material.dart';
Widget imageAndColor(Color color,String name,String link){

  return Column(
    children:[ Expanded(
      flex: 10,
      child: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: color,
            )
      ,
        child:  ClipRRect(borderRadius: BorderRadius.circular(10),
            child: Image.network(link,fit: BoxFit.contain,)),
      ),
    ),
      Text(name,style: TextStyle(fontSize:name.length>15? 10:14 ),)
    ]
  );
}
