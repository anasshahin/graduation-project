
import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages( {super.key,required this.emailReceiver});
  final  String emailReceiver;
  String sortString(String str)
  {
    List<String> char =str.split("");
    char.sort();
    return char.join("");
  }
  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser;
    String collection = authUser!.email!+emailReceiver;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(sortString(collection))
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No messages send"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          final loadedMessages = snapshot.data?.docs;
          return ListView.builder(
              itemCount: loadedMessages!.length,
              padding: const EdgeInsets.only(
                bottom: 40,
                right: 13,
                left: 13,
              ),
              reverse: true,
              itemBuilder: (ctx, index) {
                final chatMessage = loadedMessages[index].data();
                final nextMessage = index + 1 < loadedMessages.length
                    ? loadedMessages[index + 1].data()
                    : null;
                final currentMessageUserId = chatMessage['userId'];
                final nextMessageUserId =
                    nextMessage != null ? nextMessage['userId'] : null;
                bool nextUserIsSame = nextMessageUserId == currentMessageUserId;
                if (nextUserIsSame) {
                  return MessageBubble.next(
                      message: chatMessage['text'],
                      isMe: authUser.uid == currentMessageUserId);
                } else {
                  return MessageBubble.first(
                      userImage: chatMessage["userImage"],
                      username: chatMessage['username'],
                      message: chatMessage['text'],
                      isMe: authUser.uid == currentMessageUserId);
                }
                Text(
                  loadedMessages[index].data()['text'],
                );
              });
        });
  }
}
