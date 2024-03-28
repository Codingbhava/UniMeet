import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unimeet/components/appbar.dart';
import 'package:unimeet/constants/data.dart';
import 'package:unimeet/database/read.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          BackBtn: () => Navigator.pop(context), title: Text("Settings")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: currentUser(LogUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(
                    child: Text('No Data'),
                  );
                }

                // Print and display the updated data
                var userData = snapshot.data!.data()!;
                if (userData['isPhoto']) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(userData["photoURL"]),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      RemainDetails(userData["email"], userData["displayName"]),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 70,
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
                        ],
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      RemainDetails(userData["email"], userData["displayName"]),
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }
}

Widget RemainDetails(String email, String name) {
  return Column(
    children: [
      Row(
        children: [
          Icon(Icons.person),
          SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name:",
                style: TextStyle(
                    color: text, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'This is not your username or pin.\n This name will be visible in UniMeet Meeting.',
                style: TextStyle(color: text, fontSize: 14),
              )
            ],
          )
        ],
      ),
      SizedBox(
        height: 20,
      ),
      Row(
        children: [
          Icon(Icons.email),
          SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Email:",
                style: TextStyle(
                    color: text, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                email,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    ],
  );
}
