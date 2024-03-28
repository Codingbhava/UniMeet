import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _db = FirebaseFirestore.instance;
final CollectionReference _users = _db.collection('users');
User? LogUser = _auth.currentUser;
Future<DocumentSnapshot<Object?>> CurrentUserData(String userId) async {
  try {
    DocumentSnapshot<Object?> userSnapshot = await _users.doc(userId).get();
    return userSnapshot;
  } catch (error) {
    print('Error fetching user data: $error');
    // You might want to return a default or handle the error accordingly.
    return Future.error('Failed to fetch user data');
  }
}

Stream<DocumentSnapshot<Map<String, dynamic>>> currentUser(String userId) {
  try {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots();
  } catch (error) {
    print('Error fetching user data: $error');
    // You might want to return a default or handle the error accordingly.
    throw ('Failed to fetch user data');
  }
}

Stream<QuerySnapshot<Map<String, dynamic>>> get meetingsHistory => _db
    .collection('users')
    .doc(LogUser?.uid)
    .collection('meetings')
    .snapshots();
