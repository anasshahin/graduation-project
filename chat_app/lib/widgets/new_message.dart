import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key,required this.emailReceiver});
  final  String ? emailReceiver;

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
final _messageController =TextEditingController();
@override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }
_sendMessage()async{
  final enteredMessage = _messageController.text;
  if (enteredMessage.trim().isEmpty){
    return;
  }
  final user = FirebaseAuth.instance.currentUser!;
  String collection = widget.emailReceiver!+user.email!;

  final userData = await FirebaseFirestore.instance
      .collection("users")
      .doc(user.uid).get();
  FirebaseFirestore.instance
      .collection(sortString(collection))
      .add({
    "text":enteredMessage,
    "createdAt":Timestamp.now(),// get me the calender of the day
    "userId":user.uid,
    "username":userData.data()!['username'],
    "userImage":userData.data()!['image_url'],
  });
  _messageController.clear();
}
String sortString(String str)
{
  List<String> char =str.split("");
  char.sort();
  return char.join("");
}
@override
  Widget build(BuildContext context) {
    return  Padding(padding: const EdgeInsets.only(left: 15,right: 1,bottom: 14),
    child: Row(
      children: [
         Expanded(child: TextField(
          controller:_messageController ,
          autocorrect: true,
          enableSuggestions: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: "Send a message"
          ),
        )),
        IconButton(onPressed: _sendMessage,
            icon: const Icon(Icons.send),
        color: Theme.of(context).colorScheme.primary,)
      ],
    ),);
  }
}
