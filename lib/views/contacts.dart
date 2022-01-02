import 'package:chat_app_flutter/constants.dart';
import 'package:chat_app_flutter/services/auth.dart';
import 'package:chat_app_flutter/services/database.dart';
import 'package:chat_app_flutter/views/login.dart';
import 'package:chat_app_flutter/views/search.dart';
import 'package:chat_app_flutter/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    getUserInfo();
    database.getContacts(username: Constants.myName).then((value) {
      contactsStream = value;
    });
  }

  getUserInfo() async {
    Constants.myName = (await SharedPrefUtil.getUserName())!;
  }

  refreshList() {}

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
      body: Container(),
    );
  }
}
