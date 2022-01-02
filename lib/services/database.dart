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

  Future<QuerySnapshot<Map<String, dynamic>>> getUsersByEmail({
    required String email,
  }) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
  }

  uploadUserInfo({required userMap}) {
    FirebaseFirestore.instance.collection("users").add(userMap);
    print(userMap);
  }

  createChatRoom({required String chatRoomId, required chatRoomMap}) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) => print(e.toString()));
  }

  sendMessage({required String chatRoomId, required messageMap}) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("Chats")
        .add(messageMap);
  }

  getChats({required String chatRoomId}) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("Chats")
        .orderBy("timeStamp", descending: false)
        .snapshots();
  }

  getContacts({required String username}) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: username)
        .snapshots();
  }
}
