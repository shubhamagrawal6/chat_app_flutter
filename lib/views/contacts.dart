import 'dart:math';
import 'package:chat_app_flutter/constants.dart';
import 'package:chat_app_flutter/services/auth.dart';
import 'package:chat_app_flutter/services/database.dart';
import 'package:chat_app_flutter/views/login.dart';
import 'package:chat_app_flutter/views/search.dart';
import 'package:chat_app_flutter/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat.dart';

class Contacts extends StatefulWidget {
  final Auth auth;
  Contacts({required this.auth});

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  late Auth auth = widget.auth;
  Database database = new Database();
  Stream<QuerySnapshot>? contactsStream;

  getUserInfo() async {
    Constants.myName = (await SharedPrefUtil.getUserName())!;
  }

  refreshList() {
    setState(() {
      database.getContacts(username: Constants.myName).then((value) {
        contactsStream = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
    refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("ChatApp"),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LogIn(auth: auth)),
                );
              },
              icon: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            child: Icon(Icons.refresh),
            onPressed: () => refreshList(),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            child: Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Search()),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: contactsStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return ContactTile(
                      username: snapshot.data.docs
                          .elementAt(index)
                          .get("chatRoomId")
                          .toString()
                          .replaceFirst(Constants.myName, "")
                          .replaceFirst("_", ""),
                      chatRoomId: snapshot.data.docs
                          .elementAt(index)
                          .get("chatRoomId")
                          .toString(),
                    );
                  },
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ContactTile extends StatelessWidget {
  final String username;
  final String chatRoomId;

  ContactTile({required this.username, required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chat(
              chatRoomId: chatRoomId,
              username: username,
            ),
          ),
        );
      },
      child: InkWell(
        onTap: () {},
        splashColor: Colors.green,
        highlightColor: Colors.blueGrey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.primaries[Random().nextInt(
                    Colors.primaries.length,
                  )],
                ),
                child: Center(
                  child: Text(
                    username.substring(0, 1),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(width: 15),
              Flexible(
                child: Text(
                  username,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
