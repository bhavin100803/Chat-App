import 'package:chatapp/colors.dart';
import 'package:chatapp/pages/complateprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/UIHelper.dart';
import '../models/UserModel.dart';

class SignUpPage  extends StatefulWidget {
  const SignUpPage ({super.key});

  @override
  State<SignUpPage > createState() => _singuppageState();
}

class _singuppageState extends State<SignUpPage > {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();


  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();

    if(email == "" || password == "" || cPassword == "" ) {
      UIHelper.showAlertDialog(context, "Incomplete Data", "Please fill all the fields");
    }
    else if(password != cPassword ) {
      UIHelper.showAlertDialog(context, "Password Mismatch", "The passwords you entered do not match!");
    }
    else {
      signUp(email, password );
    }
  }

  void signUp(String email, String password , ) async {
    UserCredential? credential;

    UIHelper.showLoadingDialog(context, "Creating new account..");

    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password , );
    } on FirebaseAuthException catch(ex) {
      Navigator.pop(context);

      UIHelper.showAlertDialog(context, "An error occured", ex.message.toString());
    }

    if(credential != null) {
      String uid = credential.user!.uid;
      UserModel newUser = UserModel(
          uid: uid,
          email: email,
          fullname: "",
          profilepic: "",
      );
      await FirebaseFirestore.instance.collection("users").doc(uid).set(newUser.toMap()).then((value) {
        print("New User Created!");
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) {
                return CompleteProfile(userModel: newUser, firebaseUser: credential!.user!);
              }
          ),
        );
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 40,
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [

                  Text("Chat App", style: TextStyle(
                      color: color.thirdcolor,
                      fontSize: 45,
                      fontWeight: FontWeight.bold
                  ),),

                  SizedBox(height: 10,),

                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: color.thirdcolor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: color.thirdcolor),
                        ),
                        labelText: "Email Address" ,labelStyle: TextStyle(color: color.thirdcolor)
                    ),
                  ),

                  SizedBox(height: 10,),

                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: color.thirdcolor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: color.thirdcolor),
                        ),
                        labelText: "Password",labelStyle: TextStyle(color: color.thirdcolor)
                    ),
                  ),

                  SizedBox(height: 10,),

                  TextField(
                    controller: cPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: color.thirdcolor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: color.thirdcolor),
                        ),
                        labelText: "Confirm Password",labelStyle: TextStyle(color: color.thirdcolor)
                    ),
                  ),

                  SizedBox(height: 50,),

                  CupertinoButton(
                    onPressed: () {
                      checkValues();
                    },
                    color: color.thirdcolor,
                    child: Text("Sign Up"),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text("Already have an account?", style: TextStyle(
                fontSize: 16
            ),),

            CupertinoButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Log In", style: TextStyle(
                  fontSize: 16,color: color.thirdcolor
              ),),
            ),

          ],
        ),
      ),
    );
  }
}
