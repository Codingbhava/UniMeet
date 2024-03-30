import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unimeet/database/read.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;
void addToMeetingHistory(String meetingName, bool isCreate) async {
  try {
    await _db.collection('users').doc(LogUser?.uid).collection('meetings').add({
      'meetingName': meetingName,
      'createdAt': DateTime.now(),
      'isCreate': isCreate
    });
  } catch (e) {
    print(e);
  }
}

void CreateMeeting(String room, String pass, bool isScheduled) async {
  try {
    await _db
        .collection('CurrentMeet')
        .doc(room)
        .set({'room': room, 'pass': pass, 'isScheduled': isScheduled});
  } catch (e) {
    print(e);
  }
}
