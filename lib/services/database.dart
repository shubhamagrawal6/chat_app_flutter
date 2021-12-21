import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  Future<QuerySnapshot<Map<String, dynamic>>> getUsersByUsername({
    required String username,
  }) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  uploadUserInfo({required userMap}) {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }
}
