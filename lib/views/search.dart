import 'package:chat_app_flutter/services/database.dart';
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
      body: Container(
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(
            children: [
              Text(
                username,
                style: TextStyle(color: Colors.white54),
              ),
              Text(
                email,
                style: TextStyle(color: Colors.white54),
              ),
            ],
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
              backgroundColor: MaterialStateProperty.all(Colors.teal),
            ),
            child: Text(
              "Messsage",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
