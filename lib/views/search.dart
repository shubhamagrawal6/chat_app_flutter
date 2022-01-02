import 'package:chat_app_flutter/constants.dart';
import 'package:chat_app_flutter/services/database.dart';
import 'package:chat_app_flutter/views/chat.dart';
import 'package:chat_app_flutter/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Database database = new Database();
  TextEditingController usernameTEController = new TextEditingController();
  QuerySnapshot? searchSnapshot = null;

  initiateSearch() {
    database
        .getUsersByUsername(
      username: usernameTEController.text,
    )
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) => SearchTile(
              username: searchSnapshot!.docs[index].get("name"),
              email: searchSnapshot!.docs[index].get("email"),
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: usernameTEController,
                      decoration:
                          customTextFieldDecoration("Search Username..."),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: () => initiateSearch(),
                    icon: Icon(Icons.search_outlined),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            searchList(),
          ],
        ),
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  final String username;
  final String email;
  SearchTile({required this.username, required this.email});

  createChatAndRedirect({
    required BuildContext context,
    required String username,
  }) {
    List<String> users = [username, Constants.myName];

    String chatRoomId = getChatRoomId(users: users);

    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatRoomId": chatRoomId,
    };

    Database().createChatRoom(chatRoomId: chatRoomId, chatRoomMap: chatRoomMap);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(
          chatRoomId: chatRoomId,
          username: username,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.white54)),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(color: Colors.white, fontSize: 12),
                overflow: TextOverflow.fade,
                maxLines: 1,
              ),
              Text(
                email,
                style: TextStyle(color: Colors.white, fontSize: 12),
                overflow: TextOverflow.fade,
                maxLines: 1,
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () => createChatAndRedirect(
              context: context,
              username: username,
            ),
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
              backgroundColor: MaterialStateProperty.all(Colors.teal),
            ),
            child: Text(
              "Messsage",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

String getChatRoomId({required List<String> users}) {
  String a = users[0], b = users[1];
  if (a.length > b.length) {
    return "$a\_$b";
  } else if (a.length < b.length) {
    return "$b\_$a";
  } else {
    if (a.compareTo(b) > 0) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
}
