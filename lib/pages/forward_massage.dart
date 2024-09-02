import 'package:chatapp/models/MessageModel.dart';
import 'package:chatapp/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ForwardMessageScreen extends StatefulWidget {
  final MessageModel currentMessage;

  const ForwardMessageScreen({Key? key, required this.currentMessage}) : super(key: key);

  @override
  _ForwardMessageScreenState createState() => _ForwardMessageScreenState();
}

class _ForwardMessageScreenState extends State<ForwardMessageScreen> {
  late Future<List<UserModel>> _usersFuture;
  final Uuid uuid = Uuid();

  @override
  void initState() {
    super.initState();
    _usersFuture = fetchAllUsers();
  }

  Future<List<UserModel>> fetchAllUsers() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
    return querySnapshot.docs.map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forward Message'),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found.'));
          } else {
            List<UserModel> users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                UserModel user = users[index];
                return ListTile(
                  // leading: CircleAvatar(
                  //   backgroundColor: Colors.grey[300],
                  //   backgroundImage: user.profileImageUrl != null
                  //       ? NetworkImage(user.profileImageUrl!)
                  //       : AssetImage("assets/default_avatar.png") as ImageProvider,
                  // ),
                  title: Text(user.fullname ?? 'Unknown'),
                  subtitle: Text(user.email ?? ''),
                  onTap: () {
                    // Forward the message to the selected user
                    forwardMessage(widget.currentMessage, user);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  void forwardMessage(MessageModel message, UserModel recipient) async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Sort user IDs to maintain consistency
    List<String> sortedUsers = [currentUserId, recipient.uid!]..sort();

    // Check if a chatroom already exists between the current user and the recipient
    QuerySnapshot existingChatRooms = await FirebaseFirestore.instance
        .collection('chatrooms')
        .where('users', isEqualTo: sortedUsers)
        .get();

    DocumentReference chatRoomRef;

    if (existingChatRooms.docs.isNotEmpty) {
      // If a chatroom exists, use its reference
      chatRoomRef = existingChatRooms.docs.first.reference;
    } else {
      // If no chatroom exists, create a new one
      chatRoomRef = FirebaseFirestore.instance.collection('chatrooms').doc();
      await chatRoomRef.set({
        'users': sortedUsers,
        'lastMessage': message.text,
        'createdOn': FieldValue.serverTimestamp(),
      });
    }

    // Forward the message to the chatroom
    await chatRoomRef.collection('messages').add({
      'messageid': uuid.v1(),
      'sender': currentUserId,
      'createdon': DateTime.now(),
      'text': message.text,
      'seen': false,
      'isForwarded': true, // Optional
      'originalSender': message.sender, // Optional
    });

    // Update the last message in the chatroom
    await chatRoomRef.update({
      'lastMessage': message.text,
      'updatedOn': FieldValue.serverTimestamp(),
    });

    // Show a confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Message forwarded to ${recipient.fullname}!')),
    );

    // Navigate back to the ChatRoomPage
    Navigator.pop(context);
  }
}
