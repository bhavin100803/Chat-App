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

  const CompleteProfile(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<CompleteProfile> createState() => _complateprofileState();
}

class _complateprofileState extends State<CompleteProfile> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  // XFile? imageFile;

  void checkValue() {
    String fullname = fullNameController.text.trim();
    String phone = phoneController.text.toString().trim();

    if (fullname == "" || phone == "") {
      print("Please fill all fields");
    } else {
      uploadData();
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) {
        return HomePage(
            userModel: widget.userModel, firebaseUser: widget.firebaseUser);
      }),
    );
    // return homepage(: widget.userModel, firebaseuser: widget.firebaseUser);
  }

  void uploadData() async {
    String fullname = fullNameController.text.trim();
    widget.userModel.fullname = fullname;

    String phonenumber = phoneController.text.toString().trim();
    widget.userModel.phonenumber = phonenumber;


    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap());


    // FirebaseFirestore.instance.collection("users").doc(widget.userModel.uid).set(widget.userModel.toMap());
  }

  final ImagePicker _imagePicker = ImagePicker();
  String? imageUrl;
  // bool isLoading = false;
  Future<void> pickImage() async {
    try {
      XFile? res = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (res != null) {
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("failed to pick image : $e")));
    }
  }

  Future<void> uploadImageToFirebase(File image) async {
    // setState(() {
    //   isLoading = true;
    // });
    try {
      Reference reference = FirebaseStorage.instance
          .ref()
          .child("images/${DateTime.now().microsecondsSinceEpoch}.png");
      await reference.putFile(image).whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
            content: Text("Upload successfully"),
          ),
        );
      });
      imageUrl = await reference.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("failed upload image : $e"),
        ),
      );
    }
    // setState(() {
    //   isLoading = false;
    // });
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
                     // pickImage();
                  },

                  leading: Icon(Icons.photo_album),
                  title: Text("Select from Gallery"),
                ),
                ListTile(
                  onTap: () {
                    // pickImage();
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
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                // onTap: showPhotoOption,
                child: CircleAvatar(
                    radius: 80,
                    child: imageUrl == null
                        ? Icon(
                      Icons.person,
                      size: 100.0,
                      color: Colors.grey,
                    )
                        : SizedBox(
                      height: 200,
                      child: ClipOval(
                          child: Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                          )),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                    counter: Offstage(),
                    labelText: "Phone number"
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
