import 'package:chat_app_flutter/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController usernameTEController = new TextEditingController();

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
                    onPressed: () {},
                    icon: Icon(Icons.search_outlined),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
