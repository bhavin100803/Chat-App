import 'package:chatapp/colors.dart';
import 'package:chatapp/pages/homepage.dart';
import 'package:chatapp/pages/signuppage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/UIHelper.dart';
import '../models/UserModel.dart';

class LoginPage  extends StatefulWidget {
  const LoginPage ({super.key});

  @override
  State<LoginPage > createState() => _loginpageState();
}

class _loginpageState extends State<LoginPage > {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(email == "" || password == "") {
      UIHelper.showAlertDialog(context, "Incomplete Data", "Please fill all the fields");
    }
    else {
      logIn(email, password);
    }
  }

  void logIn(String email, String password) async {
    UserCredential? credential;

    UIHelper.showLoadingDialog(context, "Logging In..");

    try {
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(ex) {
      // Close the loading dialog
      Navigator.pop(context);

      // Show Alert Dialog
      UIHelper.showAlertDialog(context, "An error occured", ex.message.toString());
    }

    if(credential != null) {
      String uid = credential.user!.uid;

      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      UserModel userModel = UserModel.fromMap(userData.data() as Map<String, dynamic>);

      // Go to HomePage
      print("Log In Successful!");
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) {
              return HomePage(userModel: userModel, firebaseUser: credential!.user!);
            }
        ),
      );
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
                    cursorColor: color.thirdcolor,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: color.thirdcolor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: color.thirdcolor),
                        ),
                        labelText: "Email Address",labelStyle: TextStyle(color: color.thirdcolor)
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

                  SizedBox(height: 50,),

                  CupertinoButton(
                    onPressed: () {
                      checkValues();
                    },
                    color: color.thirdcolor,
                    child: Text("Log In"),
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

            Text("Don't have an account?", style: TextStyle(
                fontSize: 16
            ),),

            CupertinoButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) {
                        return SignUpPage();
                      }
                  ),
                );
              },
              child: Text("Sign Up", style: TextStyle(
                  fontSize: 16,color: color.thirdcolor
              ),),
            ),

          ],
        ),
      ),
    );
  }
}
