import 'dart:developer';

import 'package:chatapp/colors.dart';
import 'package:chatapp/main.dart';
import 'package:chatapp/models/ChatRoomModel.dart';
import 'package:chatapp/pages/chatroompage.dart';
import 'package:chatapp/pages/shareimage_video.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/UserModel.dart';
import 'fetchalluser.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchPage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<SearchPage> createState() => _searchpageState();
}

class _searchpageState extends State<SearchPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<User1> _users = [];
  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      setState(() {
        _users =
            querySnapshot.docs.map((doc) => User1.fromFirestore(doc)).toList();
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  TextEditingController searchController = TextEditingController();

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
        title: Text("Search",style: TextStyle(color: color.thirdcolor),),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: color.thirdcolor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: color.thirdcolor),
                    ),
                    label: Text(
                      "Phone number",
                      style: TextStyle(color: color.thirdcolor),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CupertinoButton(
                  onPressed: () {
                    setState(() {});
                  },
                  color: color.thirdcolor,
                  child: Text("Search"),
                ),
                SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .where("phonenumber", isEqualTo: searchController.text)
                        .where("phonenumber",
                            isNotEqualTo:
                                widget.userModel.phonenumber.toString())
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          QuerySnapshot dataSnapshot =
                              snapshot.data as QuerySnapshot;

                          if (dataSnapshot.docs.length > 0) {
                            Map<String, dynamic> userMap = dataSnapshot.docs[0]
                                .data() as Map<String, dynamic>;
                            print("hui");

                            UserModel searchedUser = UserModel.fromMap(userMap);

                            return ListTile(
                              onTap: () async {
                                ChatRoomModel? chatRoomModel =
                                    await getChatroomModel(searchedUser);

                                if (chatRoomModel != null) {
                                  Navigator.pop(context);
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ChatRoomPage(
                                        targetUser: searchedUser,
                                        chatroom: chatRoomModel,
                                        userModel: widget.userModel,
                                        firebaseUser: widget.firebaseUser);
                                  }));
                                }
                              },
                              leading: CircleAvatar(
                                backgroundImage: AssetImage("assets/img_2.jpg"),
                                backgroundColor: Colors.grey[500],
                              ),
                              title: Text(searchedUser.fullname!),
                              subtitle: Text(searchedUser.email!),
                              trailing: Icon(Icons.keyboard_arrow_right),
                            );
                          } else {
                            return Text("No results found!");
                          }
                        } else if (snapshot.hasError) {
                          return Text("An error occured!");
                        } else {
                          return Text("No results found!");
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 20.0),
                    height: 600.0,
                    child: ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        final user = _users[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage("assets/img_2.jpg"),
                            backgroundColor: Colors.grey[500],
                          ),
                          title: Text(user.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.email),
                              Text(user.phone.toString()),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: color.thirdcolor,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>allContact()));
        },
        child: Icon(
          Icons.people_alt_outlined,
          color: color.fourcolor,
          size: 28,
        ),
      ),
    );
  }
}

class User1 {
  final String name;
  final String email;
  final String phone;

  User1({required this.name, required this.email, required this.phone});

  factory User1.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User1(
      name: data['fullname'] ?? '',
      email: data['email'] ?? '',
      phone: data['phonenumber'] ?? '',
    );
  }
}
