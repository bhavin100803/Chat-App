import 'dart:developer';

import 'package:chatapp/colors.dart';
import 'package:chatapp/models/ChatRoomModel.dart';
import 'package:chatapp/models/firebasehelper.dart';
import 'package:chatapp/pages/chatroompage.dart';
import 'package:chatapp/pages/myphone.dart';
import 'package:chatapp/pages/searchpage.dart';
import 'package:chatapp/pages/settingpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/UserModel.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomePage({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _homepageState();
}

class _homepageState extends State<HomePage> {
  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.length > 0) {
      // Fetch the existing one
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatroom;
    } else {
      // Create a new one
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        participants: {
          widget.userModel.uid.toString(): true,
          targetUser.uid.toString(): true,
        },
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());

      chatRoom = newChatroom;

      log("New Chatroom Created!");
    }

    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            Text(
              "Chat App",
              style: TextStyle(
                  color: color.thirdcolor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home1()));
            },
            icon: Icon(Icons.settings),
          ),
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return MyPhone();
                  }),
                );
              },
              icon: Icon(
                Icons.power_settings_new,
                size: 28,
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  UserModel searchedUser = UserModel.fromMap2();
                  ChatRoomModel? chatRoomModel =
                      await getChatroomModel(searchedUser);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatRoomPage(
                              targetUser: searchedUser,
                              chatroom: chatRoomModel!,
                              userModel: widget.userModel,
                              firebaseUser: widget.firebaseUser)));
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  child: Row(
                    children: [
                      Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, bottom: 10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage("assets/img_2.jpg"),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Robot",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Chat here...",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                      .where("participants.${widget.userModel.uid}",
                          isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot chatRoomSnapshot =
                            snapshot.data as QuerySnapshot;

                        return ListView.builder(
                          itemCount: chatRoomSnapshot.docs.length,
                          itemBuilder: (context, index) {
                            ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                                chatRoomSnapshot.docs[index].data()
                                    as Map<String, dynamic>);

                            Map<String, dynamic> participants =
                                chatRoomModel.participants!;

                            List<String> participantKeys =
                                participants.keys.toList();
                            participantKeys.remove(widget.userModel.uid);

                            return FutureBuilder(
                              future: FirebaseHelper.getUserModelById(
                                  participantKeys[0]),
                              builder: (context, userData) {
                                if (userData.connectionState ==
                                    ConnectionState.done) {
                                  if (userData.data != null) {
                                    UserModel targetUser =
                                        userData.data as UserModel;

                                    return ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return ChatRoomPage(
                                                targetUser: targetUser,
                                                chatroom: chatRoomModel,
                                                userModel: widget.userModel,
                                                firebaseUser:
                                                    widget.firebaseUser);
                                            // ChatRoomPage(
                                            // chatroom: chatRoomModel,
                                            // firebaseUser: widget.firebaseUser,
                                            // userModel: widget.userModel,
                                            // targetUser: targetUser,
                                            // );
                                          }),
                                        );
                                      },
                                      leading: CircleAvatar(
                                          backgroundImage:
                                              AssetImage("assets/img_2.jpg")),
                                      title: Text(
                                        targetUser.fullname.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      subtitle: (chatRoomModel.lastMessage
                                                  .toString() !=
                                              "")
                                          ? Text(chatRoomModel.lastMessage
                                              .toString())
                                          : Text(
                                              "Say hi to your new friend!",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                            ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                } else {
                                  return Container();
                                }
                              },
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else {
                        return Center(
                          child: Text("No Chats"),
                        );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: color.thirdcolor,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: color.thirdcolor,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SearchPage(
              userModel: widget.userModel,
              firebaseUser: widget.firebaseUser,
            );
          }));
        },
        child: Icon(
          Icons.search,
          color: color.fourcolor,
          size: 28,
        ),
      ),
    );
  }
}
