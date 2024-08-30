
import 'package:chatapp/colors.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
//
// class allContact extends StatefulWidget {
//   const allContact({super.key});
//
//   @override
//   State<allContact> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<allContact> {
//
//     List<Contact> contacts = [];
//
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     getContactPermission();
//   }
//
//   void getContactPermission() async {
//     if (await Permission.contacts.isGranted) {
//       fetchContacts();
//     } else {
//       await Permission.contacts.request();
//     }
//   }
//
//   void fetchContacts() async {
//       contacts = await ContactsService.getContacts();
//
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Contacts",style: TextStyle(color: color.thirdcolor),),
//       ),
//       body: contacts.isEmpty
//           ? Center(child: CircularProgressIndicator(
//         color: color.thirdcolor,
//       ))
//           : GestureDetector(
//         onTap: (){},
//             child: ListView.builder(
//                      itemCount: contacts.length,
//                     itemBuilder: (context, index) {
//             Contact contact = contacts[index];
//             return Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ListTile(
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                  tileColor: color.thirdcolor,
//                 selectedTileColor: Colors.blue[100],
//                 title: Text(contact.displayName ?? 'Unknown',style: TextStyle(
//                   fontSize: 18,
//                   color: color.fourcolor,
//                   fontFamily: "Poppins",
//                   fontWeight: FontWeight.w500,
//                 ),
//                 ),
//                 subtitle: Text(contact.phones?.isNotEmpty ?? false
//                     ? contact.phones!.first.value ?? ''
//                     : 'No Contact Number', style: TextStyle(
//                         fontSize: 18,
//                         color: color.fourcolor,
//                         fontFamily: "Poppins",
//                         fontWeight: FontWeight.w400,
//                       ),),
//               ),
//             );
//                     },
//                   ),
//           ),
//
//
//
//
//
//       // isLoading
//       //     ? Center(
//       //   child: CircularProgressIndicator(),
//       // )
//       //     : ListView.builder(
//       //   itemCount: contacts.length,
//       //   itemBuilder: (context, index) {
//       //     return ListTile(
//       //       leading: Container(
//       //         height: MediaQuery.sizeOf(context).height,
//       //         width: MediaQuery.sizeOf(context).width,
//       //         alignment: Alignment.center,
//       //         decoration: BoxDecoration(
//       //           boxShadow: [
//       //             BoxShadow(
//       //               blurRadius: 7,
//       //               color: Colors.white.withOpacity(0.1),
//       //               offset: const Offset(-3, -3),
//       //             ),
//       //             BoxShadow(
//       //               blurRadius: 7,
//       //               color: Colors.black.withOpacity(0.7),
//       //               offset: const Offset(3, 3),
//       //             ),
//       //           ],
//       //           borderRadius: BorderRadius.circular(6),
//       //           color: Color(0xff262626),
//       //         ),
//       //         child: Text(
//       //           contacts[index].givenName![0],
//       //           style: TextStyle(
//       //             fontSize: 23,
//       //             color: Colors.primaries[
//       //             Random().nextInt(Colors.primaries.length)],
//       //             fontFamily: "Poppins",
//       //             fontWeight: FontWeight.w500,
//       //           ),
//       //         ),
//       //       ),
//       //       title: Text(
//       //         contacts[index].givenName!,
//       //         maxLines: 1,
//       //         overflow: TextOverflow.ellipsis,
//       //         style: TextStyle(
//       //           fontSize: 16,
//       //           color: Colors.blue,
//       //           fontFamily: "Poppins",
//       //           fontWeight: FontWeight.w500,
//       //         ),
//       //       ),
//       //       subtitle: Text(
//       //         contacts[index].phones![0].value!,
//       //         style: TextStyle(
//       //           fontSize: 11,
//       //           color: const Color(0xffC4c4c4),
//       //           fontFamily: "Poppins",
//       //           fontWeight: FontWeight.w400,
//       //         ),
//       //       ),
//       //       horizontalTitleGap: 12,
//       //     );
//       //   },
//       // ),
//     );
//   }
// }


class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  List<Contact> _contacts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch all contacts
      final contacts = await FastContacts.getAllContacts();
       contacts.sort((a, b) => (a.displayName ?? '').compareTo(b.displayName ?? ''));
      setState(() {
        _contacts = contacts;
      });
    } catch (e) {
      print('Failed to fetch contacts: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              tileColor: color.thirdcolor,
              title: Text(contact.displayName ??  'No Name',style: TextStyle(
                fontSize: 18,
                color: color.fourcolor,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
              ),
              ),
              subtitle: Text(contact.phones.isNotEmpty ?? false
                  ? contact.phones.first.number ?? ''
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
    );
  }
}

