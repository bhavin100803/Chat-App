
import 'dart:math';

import 'package:chatapp/colors.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

// class ContactSearchScreen extends StatefulWidget {
//   @override
//   _ContactSearchScreenState createState() => _ContactSearchScreenState();
// }
//
// class _ContactSearchScreenState extends State<ContactSearchScreen> {
//   List<Contact> contacts = [];
//   List<Contact> filteredContacts = [];
//   final TextEditingController searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     fetchContacts();
//   }
//
//   void fetchContacts() async {
//     Iterable<Contact> contactsList = await ContactsService.getContacts();
//     setState(() {
//       contacts = contactsList.toList();
//     });
//   }
//
//   void searchContact(String query) {
//     List<Contact> searchResult = [];
//     if (query.isNotEmpty) {
//       searchResult = contacts.where((contact) {
//         return contact.displayName!.toLowerCase().contains(query.toLowerCase());
//       }).toList();
//     }
//     setState(() {
//       filteredContacts = searchResult;
//     });
//   }
//
//   Future<bool> checkIfUserExists(String phoneNumber) async {
//     var userSnapshot = await FirebaseFirestore.instance
//         .collection('users')
//         .where('phoneNumber', isEqualTo: phoneNumber)
//         .get();
//     return userSnapshot.docs.isNotEmpty;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Search Contacts')),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: searchController,
//               onChanged: searchContact,
//               decoration: InputDecoration(
//                 labelText: 'Search',
//                 prefixIcon: Icon(Icons.search),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: filteredContacts.length,
//               itemBuilder: (context, index) {
//                 Contact contact = filteredContacts[index];
//                 return FutureBuilder(
//                   future: checkIfUserExists(contacts.phones.first.value),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return ListTile(
//                         title: Text(contact.displayName),
//                         subtitle: Text(contact.phones.first.value),
//                         trailing: CircularProgressIndicator(),
//                       );
//                     }
//                     if (snapshot.hasData && snapshot.data == true) {
//                       return ListTile(
//                         title: Text(contact.displayName),
//                         subtitle: Text(contact.phones.first.value),
//                         trailing: Text('User'),
//                       );
//                     } else {
//                       return ListTile(
//                         title: Text(contact.displayName),
//                         subtitle: Text(contact.phones.first.value),
//                         trailing: ElevatedButton(
//                           onPressed: () {
//                             // Handle invite action
//                           },
//                           child: Text('Invite'),
//                         ),
//                       );
//                     }
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }






class allContact extends StatefulWidget {
  const allContact({super.key});

  @override
  State<allContact> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<allContact> {

  List<Contact> contacts = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getContactPermission();
  }

  void getContactPermission() async {
    if (await Permission.contacts.isGranted) {
      fetchContacts();
    } else {
      await Permission.contacts.request();
    }
  }

  void fetchContacts() async {
    contacts = await ContactsService.getContacts();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts",style: TextStyle(color: color.thirdcolor),),
      ),
      body: contacts.isEmpty
          ? Center(child: CircularProgressIndicator(
        color: color.thirdcolor,
      ))
          : ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          Contact contact = contacts[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
               tileColor: color.thirdcolor,
              // selectedTileColor: Colors.blue[100],
              title: Text(contact.displayName ?? 'Unknown',style: TextStyle(
                fontSize: 18,
                color: color.fourcolor,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
              ),),
              subtitle: Text(contact.phones?.isNotEmpty ?? false
                  ? contact.phones!.first.value ?? ''
                  : 'No Contact Number', style: TextStyle(
                      fontSize: 18,
                      color: color.fourcolor,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                    ),),
            ),
          );
        },
      ),

      // isLoading
      //     ? Center(
      //   child: CircularProgressIndicator(),
      // )
      //     : ListView.builder(
      //   itemCount: contacts.length,
      //   itemBuilder: (context, index) {
      //     return ListTile(
      //       leading: Container(
      //         height: MediaQuery.sizeOf(context).height,
      //         width: MediaQuery.sizeOf(context).width,
      //         alignment: Alignment.center,
      //         decoration: BoxDecoration(
      //           boxShadow: [
      //             BoxShadow(
      //               blurRadius: 7,
      //               color: Colors.white.withOpacity(0.1),
      //               offset: const Offset(-3, -3),
      //             ),
      //             BoxShadow(
      //               blurRadius: 7,
      //               color: Colors.black.withOpacity(0.7),
      //               offset: const Offset(3, 3),
      //             ),
      //           ],
      //           borderRadius: BorderRadius.circular(6),
      //           color: Color(0xff262626),
      //         ),
      //         child: Text(
      //           contacts[index].givenName![0],
      //           style: TextStyle(
      //             fontSize: 23,
      //             color: Colors.primaries[
      //             Random().nextInt(Colors.primaries.length)],
      //             fontFamily: "Poppins",
      //             fontWeight: FontWeight.w500,
      //           ),
      //         ),
      //       ),
      //       title: Text(
      //         contacts[index].givenName!,
      //         maxLines: 1,
      //         overflow: TextOverflow.ellipsis,
      //         style: TextStyle(
      //           fontSize: 16,
      //           color: Colors.blue,
      //           fontFamily: "Poppins",
      //           fontWeight: FontWeight.w500,
      //         ),
      //       ),
      //       subtitle: Text(
      //         contacts[index].phones![0].value!,
      //         style: TextStyle(
      //           fontSize: 11,
      //           color: const Color(0xffC4c4c4),
      //           fontFamily: "Poppins",
      //           fontWeight: FontWeight.w400,
      //         ),
      //       ),
      //       horizontalTitleGap: 12,
      //     );
      //   },
      // ),
    );
  }
}