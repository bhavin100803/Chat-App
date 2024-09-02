// import 'dart:developer';
//
// import 'package:chatapp/main.dart';
// import 'package:chatapp/models/chatroommodel.dart';
// import 'package:chatapp/models/messagemodel.dart';
// import 'package:chatapp/models/usermodel.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class chatroompage extends StatefulWidget {
//   final UserModel targetUser;
//   final ChatRoomModel chatroom;
//   final UserModel userModel;
//   final User firebaseUser;
//   const chatroompage(
//       {super.key,
//       required this.targetUser,
//       required this.chatroom,
//       required this.userModel,
//       required this.firebaseUser});
//
//   @override
//   State<chatroompage> createState() => _chatroompageState();
// }
//
// class _chatroompageState extends State<chatroompage> {
//   TextEditingController messageController = TextEditingController();
//
//   void sendMessge() async {
//     String msg = messageController.text.trim();
//     messageController.clear();
//
//     if (msg != "") {
//       MessageModel newMessage = MessageModel(
//         messageid: uuid.v1(),
//         sender: widget.userModel.uid,
//         createdon: DateTime.now(),
//         text: msg,
//         seen: false,
//       );
//
//       FirebaseFirestore.instance
//           .collection("chatrooms")
//           .doc(widget.chatroom.chatroommid)
//           .collection("messages")
//           .doc(newMessage.messageid)
//           .set(newMessage.toMap());
//
//       // widget.chatroom.lastMessage = msg;
//       // FirebaseFirestore.instance
//       //     .collection("chatrooms")
//       //     .doc(widget.chatroom.chatroommid)
//       //     .set(widget.chatroom.toMap());
//
//       log("message sent!");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundColor: Colors.grey[300],
//               backgroundImage: AssetImage("assets/img_2.jpg"),
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             Text(widget.targetUser.fullname.toString()),
//           ],
//         ),
//         iconTheme: IconThemeData(
//           color: Colors.white, //change your color here
//         ),
//         backgroundColor: Colors.blue,
//       ),
//       body: SafeArea(
//         child: Container(
//           child: Column(
//             children: [
//               Expanded(
//                   child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 10),
//                       child: StreamBuilder(
//                         stream: FirebaseFirestore.instance
//                             .collection("chatrooms")
//                             .doc(widget.chatroom.chatroommid)
//                             .collection("messages")
//                             .orderBy("createdon", descending: true)
//                             .snapshots(),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.active) {
//                             if (snapshot.hasData) {
//                               QuerySnapshot dataSnapshot =
//                                   snapshot.data as QuerySnapshot;
//
//                               return ListView.builder(
//                                   reverse: true,
//                                   itemCount: dataSnapshot.docs.length,
//                                   itemBuilder: (context, index) {
//                                     MessageModel currentMessage =
//                                         MessageModel.formMap(
//                                             dataSnapshot.docs[index].data()
//                                                 as Map<String, dynamic>);
//                                     return Row(
//                                       mainAxisAlignment:
//                                           (currentMessage.sender ==
//                                                   widget.userModel.uid)
//                                               ? MainAxisAlignment.end
//                                               : MainAxisAlignment.start,
//                                       children: [
//                                         Container(
//                                             margin: EdgeInsets.symmetric(
//                                                 vertical: 2),
//                                             padding: EdgeInsets.symmetric(
//                                                 vertical: 10, horizontal: 10),
//                                             decoration: BoxDecoration(
//                                               color: (currentMessage.sender ==
//                                                       widget.userModel.uid)
//                                                   ? Colors.grey
//                                                   : Colors.blue,
//                                               borderRadius:
//                                                   BorderRadius.circular(5),
//                                             ),
//                                             child: Text(
//                                               currentMessage.text.toString(),
//                                               style: TextStyle(
//                                                   color: Colors.white),
//                                             )),
//                                       ],
//                                     );
//                                   });
//                             } else if (snapshot.hasError) {
//                               return Center(
//                                 child: Text(
//                                     "An error occured! Plase check your interner connection"),
//                               );
//                             } else {
//                               return Center(
//                                 child: Text("Say hii to your new friend"),
//                               );
//                             }
//                           } else {
//                             return Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           }
//                         },
//                       ))),
//               Container(
//                 color: Colors.grey[200],
//                 padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//                 child: Row(
//                   children: [
//                     Flexible(
//                       child: TextField(
//                         controller: messageController,
//                         maxLines: null,
//                         decoration: InputDecoration(
//                             border: InputBorder.none,
//                             hintText: "Enter Message"),
//                       ),
//                     ),
//                     IconButton(
//                         onPressed: () {
//                           sendMessge();
//                         },
//                         icon: Icon(
//                           Icons.send,
//                           color: Colors.blue,
//                         ))
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:developer';
import 'dart:io';

import 'package:chatapp/colors.dart';
import 'package:chatapp/main.dart';
import 'package:chatapp/models/ChatRoomModel.dart';
import 'package:chatapp/models/MessageModel.dart';
import 'package:chatapp/models/UserModel.dart';
import 'package:chatapp/pages/forward_massage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoomPage({
    Key? key,
    required this.targetUser,
    required this.chatroom,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();
  late Future<List<UserModel>> _usersFuture;

  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();

    if (msg != "") {
      // Send Message
      MessageModel newMessage = MessageModel(
          messageid: uuid.v1(),
          sender: widget.userModel.uid,
          createdon: DateTime.now(),
          text: msg,
          seen: false);

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .collection("messages")
          .doc(newMessage.messageid)
          .set(newMessage.toMap());

      widget.chatroom.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .set(widget.chatroom.toMap());

      log("Message Sent!");
    }
  }

  final ImagePicker _imagePicker = ImagePicker();
  String? imageUrl;
  bool isLoading = false;

  Future<void> pickImage() async {
    try {
      XFile? res = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (res != null) {
        await uploadImageToFirebase(File(res.path));
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

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndShareImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print(image.toString());
    if (image != null) {
      // Share the image
      Share.shareXFiles([image], text: 'Check out this image!');
    }
  }

  Future<void> _pickAndShareVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      // Share the video
      Share.shareXFiles([video], text: 'Check out this video!');
    }
  }

  void deleteMessageForUser(MessageModel message) {
    FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(widget.chatroom.chatroomid)
        .collection("messages")
        .doc(message.messageid)
        .delete();
  }

  void deleteMessageForAll(MessageModel message) {
    FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(widget.chatroom.chatroomid)
        .collection("messages")
        .doc(message.messageid)
        .update({'text': 'This message was deleted', 'deleted': true});
  }
  // void forwardMessage(MessageModel message) async {
  //   // Show a list of chat rooms to select where to forward the message
  //   ChatRoomModel? selectedChatRoom = await _selectChatRoom();
  //
  //   if (selectedChatRoom != null) {
  //     // Create a new message in the selected chat room with the same content
  //     MessageModel newMessage = MessageModel(
  //       messageid: uuid.v1(),
  //       sender: widget.userModel.uid, // The current user forwarding the message
  //       createdon: DateTime.now(),
  //       text: message.text, // Forward the original message text
  //       seen: false,
  //     );
  //
  //     FirebaseFirestore.instance
  //         .collection("chatrooms")
  //         .doc(selectedChatRoom.chatroomid)
  //         .collection("messages")
  //         .doc(newMessage.messageid)
  //         .set(newMessage.toMap());
  //
  //     // Update the last message in the selected chat room
  //     selectedChatRoom.lastMessage = newMessage.text;
  //     FirebaseFirestore.instance
  //         .collection("chatrooms")
  //         .doc(selectedChatRoom.chatroomid)
  //         .set(selectedChatRoom.toMap());
  //
  //     log("Message Forwarded!");
  //   }
  // }

  Future<ChatRoomModel?> _selectChatRoom() async {
    return showDialog<ChatRoomModel>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Chat Room"),
          content: Container(
            height: 400.0, // Adjust height as needed
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatrooms")
                    .where("users", arrayContains: widget.userModel.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;

                      if (dataSnapshot.docs.isEmpty) {
                        print(
                            "No chat rooms found for user: ${widget.userModel.uid}");
                        return Center(
                          child: Text("No chat rooms found"),
                        );
                      }

                      print(
                          "Found ${dataSnapshot.docs.length} chat rooms for user: ${widget.userModel.uid}");
                      return ListView.builder(
                        itemCount: dataSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          ChatRoomModel chatRoom = ChatRoomModel.fromMap(
                            dataSnapshot.docs[index].data()
                                as Map<String, dynamic>,
                          );

                          print("Chat Room ID: ${chatRoom.chatroomid}");

                          return ListTile(
                            title: Text(
                                "Chat Room ${chatRoom.chatroomid}"), // Customize the display
                            onTap: () {
                              Navigator.pop(context, chatRoom);
                            },
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      log("Error fetching chat rooms: ${snapshot.error}");
                      return Center(
                        child: Text("Error loading chat rooms"),
                      );
                    } else {
                      return Center(
                        child: Text("No chat rooms found"),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: color.five),
        backgroundColor: color.fourcolor,
        title: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    backgroundImage: AssetImage("assets/img_2.jpg")),
                SizedBox(
                  width: 10,
                ),
                Text(
                  widget.targetUser.fullname.toString(),
                  style: TextStyle(color: color.five),
                ),

                // IconButton(
                //     onPressed: () {
                //       FirebaseFirestore.instance
                //           .collection("chatrooms")
                //           .doc(widget.chatroom.chatroomid)
                //           .delete();
                //     },
                //     icon: Icon(Icons.clear))
                // TextButton(
                //   onPressed: (){
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) =>
                //     CallPage(callID: widget.targetUser.uid.toString())));
                //                 CallPage(callID: 1.toString(), userID: widget.targetUser.uid.toString(), username: widget.targetUser.fullname.toString())));
                //   }, child: Icon(Icons.videocam_rounded,size: 30,),),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: color.fourcolor,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: MediaQuery.sizeOf(context).height / 1.2,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                      .doc(widget.chatroom.chatroomid)
                      .collection("messages")
                      .orderBy("createdon", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnapshot =
                            snapshot.data as QuerySnapshot;

                        return ListView.builder(
                          reverse: true,
                          itemCount: dataSnapshot.docs.length,
                          itemBuilder: (context, index) {
                            MessageModel currentMessage = MessageModel.fromMap(
                                dataSnapshot.docs[index].data()
                                    as Map<String, dynamic>);

                            return GestureDetector(
                              onLongPress: () {
                                print(
                                    dataSnapshot.docs[index].data().toString());
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SafeArea(
                                      child: Wrap(
                                        children: [
                                          ListTile(
                                            leading: Icon(Icons.reply),
                                            title: Text('Reply'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              // Handle reply
                                              // replyToMessage(currentMessage);
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.copy),
                                            title: Text('Copy'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              Clipboard.setData(ClipboardData(
                                                  text: currentMessage.text ??
                                                      ""));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Message copied!')),
                                              );
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.forward),
                                            title: Text('Forward'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              // Handle forward
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ForwardMessageScreen(
                                                            currentMessage:
                                                                currentMessage),
                                                  ));
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.delete),
                                            title: Text('Delete for Me'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              deleteMessageForUser(
                                                  currentMessage);
                                            },
                                          ),
                                          if (currentMessage.sender ==
                                              widget.userModel.uid)
                                            ListTile(
                                              leading:
                                                  Icon(Icons.delete_forever),
                                              title:
                                                  Text('Delete for Everyone'),
                                              onTap: () {
                                                Navigator.pop(context);
                                                deleteMessageForAll(
                                                    currentMessage);
                                              },
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Column(
                                crossAxisAlignment: (currentMessage.sender ==
                                        widget.userModel.uid)
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: (currentMessage.sender ==
                                              widget.userModel.uid)
                                          ? color.thirdcolor
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      style: TextStyle(color: Colors.white),
                                      currentMessage.text.toString(),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                              "An error occured! Please check your internet connection."),
                        );
                      } else {
                        return Center(
                          child: Text("Say hi to your new friend"),
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
              Container(
                // width: MediaQuery.sizeOf(context).width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: TextField(
                            controller: messageController,
                            maxLines: null,
                            decoration: InputDecoration(
                                // suffixIcon: IconButton(
                                //   onPressed: pickImage,
                                //   icon: Icon(Icons.photo),
                                // ),
                                border: InputBorder.none,
                                hintText: "Enter message",
                                hintStyle: TextStyle(color: color.five)),
                          ),
                          height: MediaQuery.sizeOf(context).height / 14,
                          width: MediaQuery.sizeOf(context).width / 3,
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: pickImage,
                              icon: Icon(
                                Icons.photo,
                                color: color.five,
                              ),
                            ),
                            GestureDetector(
                              onTap: showButton,
                              child: Icon(
                                Icons.attach_file,
                                color: color.five,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                sendMessage();
                              },
                              icon: Icon(
                                Icons.send,
                                color: color.five,
                              ),
                            ),
                            // IconButton(onPressed: (){
                            //   // Navigator.push(context, MaterialPageRoute(builder: (context)=>Shareaudio()));
                            // }, icon: Icon(Icons.mic))
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showButton() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Select and Share"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndShareImage();
                  },
                  leading: Icon(Icons.photo_album),
                  title: Text("Select Photo Gallery"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndShareVideo();
                  },
                  leading: Icon(Icons.videocam),
                  title: Text("Select Video Gallery"),
                )
              ],
            ),
          );
        });
  }
}
