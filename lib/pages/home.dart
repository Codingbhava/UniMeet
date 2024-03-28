import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unimeet/constants/data.dart';
import 'package:unimeet/context/meet.dart';
import 'package:unimeet/database/read.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final JitsiMeetMethods _jitsiMeetMethods = JitsiMeetMethods();

  createNewMeeting() async {
    var random = Random();
    String roomName = (random.nextInt(10000000) + 10000000).toString();
    _jitsiMeetMethods.createMeeting(roomName: roomName, isCreate: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: ElevatedButton.icon(
          onPressed: createNewMeeting,
          icon: Icon(Icons.add),
          label: Text("New Meet")),
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
                              Navigator.pushNamed(context, '/join'),
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
                              Navigator.pushNamed(context, '/scheduled'),
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
                              Navigator.pushNamed(context, '/profile'),
                          icon: Icon(Icons.person),
                          label: Text("Profile"))),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: currentUser(LogUser!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: LinearProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Center(
                        child: Text('not admin'),
                      );
                    }

                    // Print and display the updated data
                    var userData = snapshot.data!.data()!;
                    if (userData["email"].toString() ==
                        "omkarsingh19012003@gmail.com") {
                      return Row(
                        children: [
                          Expanded(
                              child: ElevatedButton.icon(
                                  onPressed: () =>
                                      Navigator.pushNamed(context, '/admin'),
                                  icon:
                                      Icon(Icons.admin_panel_settings_outlined),
                                  label: Text("Admin"))),
                        ],
                      );
                    } else {
                      return SizedBox();
                    }
                  }),
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
                    color: Color.fromARGB(172, 196, 196, 161).withOpacity(0.3),
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
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/join'),
                            child: Text(
                              "Enter a Code ",
                            ),
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
                                onTap: () =>
                                    Navigator.pushNamed(context, '/profile'),
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(userData["photoURL"]),
                                ),
                              );
                            } else {
                              return GestureDetector(
                                onTap: () =>
                                    Navigator.pushNamed(context, '/profile'),
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
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: meetingsHistory,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData ||
                        (snapshot.data! as dynamic).docs.isEmpty) {
                      return Center(
                        child: Text(
                          'Join OR Create Meetings',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }

                    return ListView.builder(
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) => Card(
                              elevation: 13,
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Room Id: ${(snapshot.data! as dynamic).docs[index]['meetingName']}',
                                        ),
                                        if ((snapshot.data! as dynamic)
                                            .docs[index]['isCreate'])
                                          Chip(
                                            backgroundColor: neonBlue,
                                            label: Text(
                                              "Created",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        else
                                          Chip(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 143, 107, 0),
                                            label: Text("Joined",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Joined on ${DateFormat.yMMMd().format((snapshot.data! as dynamic).docs[index]['createdAt'].toDate())}',
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
