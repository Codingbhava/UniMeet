import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:unimeet/components/appbar.dart';
import 'package:unimeet/constants/data.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  CollectionReference _users = FirebaseFirestore.instance.collection('users');
  TextEditingController _searchController = TextEditingController();
  late Stream<QuerySnapshot> _filteredUsersStream;

  @override
  void initState() {
    super.initState();
    _filteredUsersStream = _users.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          BackBtn: () => Navigator.pop(context), title: Text("Admin ")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Email',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _filteredUsersStream = _users.snapshots();
                    });
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _filteredUsersStream = _users
                      .where('email', isGreaterThanOrEqualTo: value)
                      .where('email', isLessThan: value + 'z')
                      .snapshots();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _filteredUsersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LinearProgressIndicator();
                }

                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> userData =
                        document.data() as Map<String, dynamic>;
                    String userId = document.id;
                    return ListTile(
                      title: Text('Email Id: ${userData['email']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Meetings:'),
                          FutureBuilder<QuerySnapshot>(
                            future:
                                _users.doc(userId).collection('meetings').get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> meetingSnapshot) {
                              if (meetingSnapshot.hasError) {
                                return Text('Error: ${meetingSnapshot.error}');
                              }

                              if (meetingSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return LinearProgressIndicator();
                              }

                              List<Widget> meetingList = [];
                              meetingSnapshot.data!.docs
                                  .forEach((DocumentSnapshot meetingDoc) {
                                Map<String, dynamic> meetingData =
                                    meetingDoc.data() as Map<String, dynamic>;
                                String meetingName = meetingData['meetingName'];
                                Timestamp createdAt = meetingData['createdAt'];
                                bool isCreate = meetingData['isCreate'];

                                meetingList.add(
                                  ListTile(
                                    title: Text('Meeting: $meetingName'),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            'Created At: ${DateFormat.yMMMMEEEEd().add_jm().format(createdAt.toDate())}'),
                                        Text(isCreate ? "Created" : "Joined",
                                            style: TextStyle(
                                                color: Colors.white,
                                                backgroundColor: isCreate
                                                    ? neonBlue
                                                    : Color.fromARGB(
                                                        255, 143, 107, 0))),
                                      ],
                                    ),
                                  ),
                                );
                              });

                              return Column(
                                children: meetingList,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
