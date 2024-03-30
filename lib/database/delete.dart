import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;
void DeleteMeeting(String room) async {
  try {
    await _db.collection('CurrentMeet').doc(room).delete();
  } catch (e) {
    print(e);
  }
}
