import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unimeet/database/read.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;
final CollectionReference _users = _db.collection('users');

Future<void> RegisterData(User user, String username, String email) async {
  final data = {
    "uid": user.uid,
    "displayName": username,
    "email": email,
    "isPhoto": false
  };
  print(data);
  await _users
      .doc(user.uid)
      .set(data)
      .onError((e, _) => print("Register Data store error 'users' : $e"));
}

Future<void> GoogleData(User user) async {
  final data = {
    "uid": user.uid,
    "displayName": user.displayName,
    "email": user.email,
    'photoURL': user.photoURL,
    "isPhoto": true
  };
  DocumentSnapshot<Object?> userData = await CurrentUserData(user.uid);
  if (!userData.exists) {
    await _users.doc(user.uid).set(data).onError((e, _) {
      print("Google Data store error 'users' : $e");
    });
  }
}
