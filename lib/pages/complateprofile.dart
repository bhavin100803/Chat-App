import 'dart:io';
import 'package:chatapp/colors.dart';
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
  File? image;

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
  bool isLoading = false;
  Future<void> pickImage() async {
    try {
      XFile? res = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (res != null) {
        await uploadImageToFirebase(File(res.path));
        setState(() {
          image = File(res.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("failed to pick image : $e")));
    }
  }

  Future<void> cameraImage() async {
    try {
      XFile? res = await _imagePicker.pickImage(source: ImageSource.camera);
      if (res != null) {
        await uploadImageToFirebase(File(res.path));
        setState(() {
          image = File(res.path);
        });
        print(res.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("failed to pick image : $e")));
    }
  }

  Future<void> uploadImageToFirebase(File image) async {
    setState(() {
      isLoading = true;
    });
    try {
      Reference reference = FirebaseStorage.instance
          .ref()
          .child("images/${DateTime.now().microsecondsSinceEpoch}.png");
      await reference.putFile(image).whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
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
    setState(() {
      isLoading = false;
    });
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
                    Navigator.pop(context);
                    pickImage();
                  },
                  leading: Icon(
                    Icons.photo_album,
                    color: color.thirdcolor,
                  ),
                  title: Text("Select from Gallery"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    cameraImage();
                  },
                  leading: Icon(
                    Icons.camera_alt,
                    color: color.thirdcolor,
                  ),
                  title: Text("Take a photo from Camera"),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: color.fourcolor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Complete Profile",
          style:
              TextStyle(color: color.thirdcolor, fontWeight: FontWeight.bold),
        ),
        // backgroundColor: color.fourcolor,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: ListView(
            shrinkWrap: true,
            children: [
              Stack(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: showPhotoOption,
                      child: CircleAvatar(
                        backgroundImage: (image != null)
                            ? FileImage(image!)
                            : AssetImage("assets/img_2.jpg"),
                        backgroundColor: color.thirdcolor.withOpacity(0.5),
                        radius: 100,
                        // child: imageUrl == null
                        //     ? Icon(
                        //         Icons.person,
                        //         size: 200.0,
                        //         color: color.thirdcolor,
                        //       )
                        //     : SizedBox(
                        //         height: 200,
                        //         child: ClipOval(
                        //             child: Image.network(
                        //           imageUrl!,
                        //           fit: BoxFit.fill,
                        //         )),
                        //       ),
                      ),
                    ),
                  ),
                  if (isLoading)
                    Positioned(
                        top: 85.0,
                        left: 160.0,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: color.thirdcolor,
                          ),
                        )),
                  // Positioned(
                  //   left: 250,
                  //   top: 120,
                  //   child: GestureDetector(
                  //     onTap: () {
                  //        showPhotoOption();
                  //     },
                  //     child: Icon(
                  //       Icons.camera_alt,
                  //       color:color.my_Primariycolor,
                  //       size: 30,
                  //     ),
                  //   ),
                  // )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: color.thirdcolor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: color.thirdcolor),
                    ),
                    labelText: "Full Name",
                    labelStyle: TextStyle(color: color.thirdcolor)),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: color.thirdcolor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: color.thirdcolor),
                    ),
                    counter: Offstage(),
                    labelText: "Phone number",
                    labelStyle: TextStyle(color: color.thirdcolor)),
              ),
              SizedBox(
                height: 40,
              ),
              CupertinoButton(
                onPressed: () {
                  checkValue();
                },
                color: color.thirdcolor,
                child: Text(
                  "Submit",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
