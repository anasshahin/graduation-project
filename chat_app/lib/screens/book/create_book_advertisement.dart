import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../models/advertisement_model.dart';
import '../../services/lists.dart';
import '../../services/provider_management.dart';
import '../../widgets/user_image.dart';

class CreateBookAdvertisement extends StatefulWidget {
  const CreateBookAdvertisement({super.key});

  @override
  State<CreateBookAdvertisement> createState() => _CreateBookAdvertisementState();
}

class _CreateBookAdvertisementState extends State<CreateBookAdvertisement> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController bookName = TextEditingController();
  final TextEditingController bookDetails = TextEditingController();

  String targetCollege = "college";

  String targetDepartment = "department";

  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Add book advertisement",
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20))),
          backgroundColor: Colors.green.shade900),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  "Book name",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: bookName,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Type your book name ...",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade400,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Book details",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: bookDetails,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Type your book details ...",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      prefixIcon: Icon(
                        Icons.drive_file_rename_outline,
                        color: Colors.grey.shade400,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                ExpansionTile(
                  title:  Text(targetCollege),
                  backgroundColor: Colors.grey,
                  children: listCollege.map((college) {
                    return TextButton(
                        child: Text(college),
                        onPressed: () {
                          setState(() {
                            targetCollege = college;

                          });
                        });
                  }).toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                if(targetCollege != 'college')
                ExpansionTile(

                  title:  Text(targetDepartment),
                  backgroundColor: Colors.grey,
                  children: listDepartment[targetCollege]!.map((department) {
                    return TextButton(
                        child: Text(department),
                        onPressed: () {
                          setState(() {
                            targetDepartment = department;
                          });
                        });
                  }).toList(),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Choose image for your book ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: UserImage(onPickImage: (File pickedImage) {
                    _selectedImage = pickedImage;
                  }),
                ),
                ElevatedButton(
                  onPressed: () {
                    if(bookName.text!="" && bookDetails.text!="" && _selectedImage!=null&&targetCollege!="college"&&targetDepartment!="department"){
                      var emailUser = FirebaseAuth.instance.currentUser?.email;
                      var ads = Advertisement(
                        name:   bookName.text,
                        image:   _selectedImage!,
                        department:  targetDepartment,
                        college:   targetCollege,
                        email:   emailUser!,
                        details:  bookDetails.text,
                      );

                      Provider.of<AdvertisementProvider>(context, listen: false)
                          .addAdvertisement(ads);
                      Provider.of<AdvertisementProvider>(context, listen: false).selectedIndex=0;
                      setState(() {
                        bookName.text="";
                        targetCollege = "college";
                        targetDepartment = "department";
                        bookDetails.text ="";
                        pickedImageFile=null;
                      });

                    }else{
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("please fill all missing value")));
                    }

                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 20))),
                  child: const Text("Submit"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
