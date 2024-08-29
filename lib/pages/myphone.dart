import 'package:chatapp/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'otppage.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({super.key,});

  static String verify="";

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {

  TextEditingController countrycode = TextEditingController();
  var phone ="";

  @override
  void initState() {
    countrycode.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Container(
          margin: EdgeInsets.only(left: 25, right: 25),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Phone Verificatinon",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "We need to register phone before getting started !",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30,),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 30,
                        child: TextField(
                          controller: countrycode,
                          decoration: InputDecoration(border: InputBorder.none),
                        ),
                      ),

                      Text(
                        " | ",
                        style: TextStyle(fontSize: 33, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Expanded(
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            onChanged: (value){
                              phone=value;
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: "Phone"),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async
                    {
                      await FirebaseAuth.instance.verifyPhoneNumber(
                         phoneNumber: "${countrycode.text + phone}",
                        verificationCompleted: (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException ex) {},
                        codeSent: (String verificationId, int? resendToken) {
                            MyPhone.verify = verificationId;
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>MyOtp(verificationid: verificationId))
                          );
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                       // Navigator.push(context, MaterialPageRoute(builder: (context)=>MyOtp(verificationid: '',)));

                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: color.thirdcolor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
