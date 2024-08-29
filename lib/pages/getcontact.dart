// import 'package:flutter/material.dart';
// import 'package:contacts_service/contacts_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
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
//         return contact.displayName.toLowerCase().contains(query.toLowerCase());
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
//                   future: checkIfUserExists(contact.phones.first.value),
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