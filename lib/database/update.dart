import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;
final CollectionReference _users = _db.collection('users');
Future<void> UpdateUser(final data, String userId) async {
  await _users
      .doc(userId)
      .update(data)
      .onError((e, _) => print("Data update error 'users' : $e"));
}

Future<void> UpdateMeet(final data, String room) async {
  await _db
      .collection('CurrentMeet')
      .doc(room)
      .update(data)
      .onError((e, _) => print("Data update error 'users' : $e"));
}
