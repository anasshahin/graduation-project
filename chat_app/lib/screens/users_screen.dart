import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: const Text("chat with users"),centerTitle: true),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (ctx, snapshots) {
            final loadedMessages = snapshots.data?.docs.where(
                    (element) => element.data()["connectedPeople"].
                    contains(FirebaseAuth.instance.currentUser?.email)).toList();
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
            return ListView.builder(
              padding: const EdgeInsets.only(top: 50),
              itemCount: loadedMessages?.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(loadedMessages?[index].data()['username']),
                    contentPadding: const EdgeInsets.all(15),
                    leading: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      foregroundImage:
                          loadedMessages?[index].data()['image_url'] == null
                              ? null
                              : NetworkImage(
                                  loadedMessages?[index].data()['image_url']),
                    ),
                    onTap: (){
                      

                      Navigator.of(context).push(MaterialPageRoute(builder: (_){
                        return  ChatScreen(emailReceiver: loadedMessages?[index].data()['email'],);
                      }));
                    },
                  ),
                );
              },
            );
          }),
    );
  }
}
