import 'dart:io';
import 'dart:math';

import 'package:chatapp/pages/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/UserModel.dart';


class CompleteProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const CompleteProfile({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  State<CompleteProfile> createState() => _complateprofileState();
}

class _complateprofileState extends State<CompleteProfile> {
  TextEditingController fullNameController = TextEditingController();

  XFile? imageFile;

  //   final picker = ImagePicker();
  //   if (pickGalleryImage == true) {
  //     image = await picker.pickImage(source: ImageSource.gallery);
  //   } else {
  //     image = await picker.pickImage(source: ImageSource.camera);
  //   }
  //
  //   if (image != null) {
  //     final croppedImage = await cropImages(image);
  //   }
  // }
  //
  // Future cropImages(XFile image) async {
  //   final CroppedFile = await ImageCropper().cropImage(sourcePath: image.path,
  //   aspectRatioPresets: [
  //     CropAspectRatioPreset.square,
  //     CropAspectRatioPreset.ratio4x3,
  //     CropAspectRatioPreset.original,
  //     CropAspectRatioPreset.ratio7x5,
  //     CropAspectRatioPreset.ratio16x9
  //   ],
  //     AndroidUiSettings(
  //
  //     )
  //   );
  //
  //   return CroppedFile;
  // }

  // void selectImage(ImageSource source) async {
  //   XFile? pickedFile = await ImagePicker().pickImage(source: source);
  //
  //   if (pickedFile != null) {
  //     cropImage(pickedFile);
  //   }

  // void cropImage(XFile file) async {
  // File? croppedImage = await ImageCropper.cropImage(sourcePath: file.path);
  //
  //   if (croppedImage != null) {
  //     setState(() {
  //       imageFile = croppedImage;
  //     });
  //   }
  // }

  void checkValue() {
    String fullname = fullNameController.text.trim();

    if (fullname == "") {
      print("Please fill all fields");
    } else {
      uploadData();

    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) {
        return HomePage(userModel: widget.userModel, firebaseUser: widget.firebaseUser);
      }),
    );
      // return homepage(: widget.userModel, firebaseuser: widget.firebaseUser);
  }
   void uploadData()async{
     String fullname = fullNameController.text.trim();
     widget.userModel.fullname = fullname;

     await FirebaseFirestore.instance.collection("users").doc(widget.userModel.uid).set(widget.userModel.toMap());
   }

  void showPhotoOption() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Upload profile picture"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    // selectImage(ImageSource.gallery);
                  },
                  leading: Icon(Icons.photo_album),
                  title: Text("Select from Gallery"),
                ),
                ListTile(
                  onTap: () {
                    // selectImage(ImageSource.camera);
                  },
                  leading: Icon(Icons.camera_alt),
                  title: Text("Take a photo"),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("Complete Profile"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 40
          ),
          child: ListView(
            children: [

              SizedBox(height: 20,),


              SizedBox(height: 20,),

              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                ),
              ),

              SizedBox(height: 20,),

              CupertinoButton(
                onPressed: () {
                  checkValue();
                },
                color: Theme.of(context).colorScheme.secondary,
                child: Text("Submit"),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
