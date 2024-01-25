import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'UserStatus.dart';

class UserStatusService {
  final DatabaseReference _userStatusRef =
  FirebaseDatabase.instance.reference().child('userStatus');

  Future<void> setUserStatus(bool isOnline) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _userStatusRef.child(user.uid).set({
        'isOnline': isOnline,
        'lastOnline': ServerValue.timestamp,
      });
    }
  }

  Stream<UserStatus?> listenToUserStatus() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return _userStatusRef.child(user.uid).onValue.map((event) {
        final data = event.snapshot.value;
        if (data != null) {
          return UserStatus(
            isOnline: true,
            lastOnline: DateTime.fromMillisecondsSinceEpoch(10),
          );
        }
        return null;
      });
    }
    return Stream.empty();
  }
}
