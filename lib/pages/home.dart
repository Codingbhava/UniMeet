import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unimeet/constants/data.dart';
import 'package:unimeet/database/read.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: ElevatedButton.icon(
          onPressed: () {}, icon: Icon(Icons.add), label: Text("New Meet")),
      drawer: Drawer(
        width: findWidth(context) / 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton.icon(
                          onPressed: () =>
                              Navigator.popAndPushNamed(context, '/join'),
                          icon: Icon(Icons.meeting_room),
                          label: Text("Join Meet"))),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton.icon(
                          onPressed: () =>
                              Navigator.popAndPushNamed(context, '/scheduled'),
                          icon: Icon(Icons.schedule_outlined),
                          label: Text("Scheduled"))),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton.icon(
                          onPressed: () =>
                              Navigator.popAndPushNamed(context, '/settings'),
                          icon: Icon(Icons.settings),
                          label: Text("Settings"))),
                ],
              ),
              SizedBox(
                height: findHeight(context) / 2,
              ),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton.icon(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.popAndPushNamed(context, '/usercheck');
                          },
                          icon: Icon(Icons.exit_to_app),
                          label: Text("Sign Out"))),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Container(
                  decoration: BoxDecoration(
                      color:
                          Color.fromARGB(172, 196, 196, 161).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(100)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                                onTap: () =>
                                    _scaffoldKey.currentState?.openDrawer(),
                                child: Icon(Icons.menu)),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Enter a Code ",
                            ),
                          ],
                        ),
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            stream: currentUser(LogUser!.uid),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (!snapshot.hasData || !snapshot.data!.exists) {
                                return Center(
                                  child: Text('Document does not exist'),
                                );
                              }

                              // Print and display the updated data
                              var userData = snapshot.data!.data()!;

                              if (userData['isPhoto']) {
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Dialog Title'),
                                          content: Text(
                                              'This is the content of the dialog.'),
                                          actions: <Widget>[
                                            // Define buttons for the dialog
                                            TextButton(
                                              onPressed: () {
                                                // Close the dialog
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Close'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(userData["photoURL"]),
                                  ),
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Dialog Title'),
                                          content: Text(
                                              'This is the content of the dialog.'),
                                          actions: <Widget>[
                                            // Define buttons for the dialog
                                            TextButton(
                                              onPressed: () {
                                                // Close the dialog
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Close'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundColor:
                                        const Color.fromARGB(255, 228, 195, 98),
                                    child: Text(
                                      userData["displayName"]
                                          .toString()[0]
                                          .toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            })
                      ],
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  child: ListView(
                children: [
                  const Card(
                    elevation: 20,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Room ID:"),
                              Text("442422424"),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Date:"),
                              Text("442422424"),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}


// Widget buildUser(
//     Map<String, dynamic> userdata,
//     BuildContext context,
//     VoidCallback onClick,
//     Color background,
//     bool isShowBadge,
//     bool isShowQr,
//     VoidCallback Qrcode) {
//   return GestureDetector(
//     onTap: onClick,
//     child: Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(Radius),
//         color: background,
//       ),
//       padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       margin: EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Avatar(
//             size: 55,
//             user: userdata,
//             textsize: 40,
//             isShowBadge: isShowBadge,
//           ),
//           SizedBox(width: 16.0),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     if (userdata.containsKey('displayName'))
//                       Text(
//                         userdata['displayName'],
//                         style: TextStyle(
//                             fontSize: 12.0,
//                             fontFamily: "VALORANT",
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                       ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Icon(
//                       Icons.verified,
//                       color: neonBlue,
//                     ),
//                   ],
//                 ),
//                 if (userdata.containsKey('email'))
//                   Text(
//                     userdata['email'],
//                     style: TextStyle(fontSize: 14.0, color: text),
//                   ),
//               ],
//             ),
//           ),
//           if (isShowQr)
//             IconButton(
//                 icon: Icon(Icons.qr_code_rounded),
//                 onPressed: Qrcode,
//                 color: common),
//         ],
//       ),
//     ),
//   );
// }
