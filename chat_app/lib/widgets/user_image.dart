
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
File? pickedImageFile;

class UserImage extends StatefulWidget {
  const UserImage({super.key,required this.onPickImage});
final void Function(File pickedImage) onPickImage;
  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  void _pickImage(ImageSource imageSource) async {
 final XFile? pickedImage= await  ImagePicker().pickImage(source: imageSource,
        maxWidth: 150,imageQuality: 50);
 if (pickedImage==null)
 {
   return;
 }
 setState(() {
   pickedImageFile = File(pickedImage.path);
 });
 widget.onPickImage(pickedImageFile!);
  }
  void _pickImageChoose(){
    showDialog<Null>(
        context: context,
        builder: (innerContext) =>
            AlertDialog(
              title: const Text(
                  "choose away to select image "),

              actions: [
                OutlinedButton(
                    onPressed: (){
                      _pickImage(ImageSource.camera);

                      Navigator.of(context)
                            .pop();},
                    child: const Text("camera")),
                OutlinedButton(
                    onPressed: (){
                      _pickImage(ImageSource.gallery);
                      Navigator.of(context)
                          .pop();},
                    child: const Text("gallery")),
              ],
            ));
    }
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
         foregroundImage:pickedImageFile ==null ? null :FileImage(pickedImageFile!) ,

        ),
         Container(
           margin:const EdgeInsets.symmetric(vertical: 10),
           decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
           color: Colors.green.shade900),

           child: TextButton.icon(onPressed: _pickImageChoose, icon: const Icon(Icons.image,color:  Colors.white70), label: const Text('Add image',style: TextStyle(
            color: Colors.white70,
                   )),
                   ),
         )
      ],
    );
  }
}
