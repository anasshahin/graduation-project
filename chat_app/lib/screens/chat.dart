import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:flutter/material.dart';
class ChatScreen extends StatelessWidget {
   const ChatScreen({super.key,required this.emailReceiver});
 final  String emailReceiver;
   @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title:const Text('main screen') ,
     ),
      body: Column(
          children: [
            Expanded(
                child: ChatMessages(emailReceiver: emailReceiver,),
            ),
            NewMessage(emailReceiver: emailReceiver),
          ]),
    );
  }
}
