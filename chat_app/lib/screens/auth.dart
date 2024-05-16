import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets/user_image.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = false;
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = "";
  var _userName = "";
  var _enteredPassword = "";
  File? _selectedImage;
  bool _isUploading = false;

  void _submit() async {
    final valid = _formKey.currentState!.validate();
    if (!valid || (!isLogin && _selectedImage == null)) return;
    _formKey.currentState!.save();
    // this instruction mean that active onSaved (execute instruction that is on it)

    if (isLogin) {
      try {
        setState(() {
          _isUploading = true;
        });
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.message!)));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.message!),
            duration: const Duration(seconds: 5),
          ));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.message!)));
          setState(() {
            _isUploading = false;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
        setState(() {
          _isUploading = false;
        });
      }
      setState(() {
        _isUploading = false;
      });
    } else {
      try {
        setState(() {
          _isUploading = true;
          pickedImageFile=null;
        });
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child("user_images")
            .child("${credential.user!.uid}.jpg");
        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();
        log(imageUrl);
        FirebaseFirestore.instance
            .collection("users")
            .doc(credential.user!.uid).set({
          "username":_userName,
          "email":_enteredEmail,
          "image_url":imageUrl,
          "connectedPeople":[],
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.message!)));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.message!)));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.message!)));
          setState(() {
            _isUploading = false;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
        setState(() {
          _isUploading = false;
        });
      }
    }

    log("$_enteredEmail\n");
    log(_enteredPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(
                  top: 30, right:60, bottom: 20,),
              child:  Image.asset(
                'assets/images/Group.png',
                height: 250.0,
                // width: 20.0,
               // allowDrawingOutsideViewBox: true,
              ),
            ),
            Card(
              color: Theme.of(context).cardColor,
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (!isLogin)
                            UserImage(onPickImage: (File pickedImage) {
                              _selectedImage = pickedImage;
                            }),
                          TextFormField(
                            style: const TextStyle(color: Colors.white70 ),
                            decoration: const InputDecoration(
                              labelText: "Email address",
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            onSaved: (value) => _enteredEmail = value!,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains("@")) {
                                return "please enter a valid email address";
                              }

                              return null;
                            },
                          ),
                          if (!isLogin)
                            TextFormField(
                              style: TextStyle(color:Colors.white70 ),
                            decoration: const InputDecoration(
                              labelText: "User name",
                            ),
                            onSaved: (value) => _userName = value!,
                            validator: (value) {
                              if (value == null ||

                                  value.length <2) {
                                return "user name must include 3 character";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            style: const TextStyle(color:Colors.white70 ),
                            decoration:  const InputDecoration(
                              labelText: "Password",
                            ),
                            obscureText: true,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            onSaved: (value) => _enteredPassword = value!,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return "Password must be at least 6 characters long. ";
                              }

                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          if (_isUploading) const CircularProgressIndicator(),
                          if (!_isUploading)
                            ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .buttonTheme.colorScheme?.primary),
                                child: Text(isLogin ? "Login" : 'Signup',style: const TextStyle(color: Colors.white70))),
                          const SizedBox(
                            height: 12,
                          ),
                          if (!_isUploading)
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    isLogin = !isLogin;
                                  });
                                },
                                //style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primaryContainer),
                                child: Text(!isLogin
                                    ? "I already have an account"
                                    : 'Create an account',style: const TextStyle(color: Colors.white70)),),
                        ],
                      )),
                )),
          ],
        ),
      ),
    );
  }
}
