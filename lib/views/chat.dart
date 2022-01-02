import 'package:chat_app_flutter/constants.dart';
import 'package:chat_app_flutter/services/database.dart';
import 'package:chat_app_flutter/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;
  final String username;

  Chat({required this.chatRoomId, required this.username});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController messageTEController = new TextEditingController();
  Database database = new Database();
  Stream<QuerySnapshot>? chatMsgStream;

  refreshChats() {
    setState(() {
      database.getChats(chatRoomId: widget.chatRoomId).then((value) {
        chatMsgStream = value;
      });
    });
  }

  void initState() {
    refreshChats();
    super.initState();
  }

  sendMessage() {
    if (messageTEController.text.isNotEmpty) {
      Map<String, String> messageMap = {
        "message": messageTEController.text,
        "sentBy": Constants.myName,
        "timeStamp": DateTime.now().millisecondsSinceEpoch.toString(),
      };
      database.sendMessage(
        chatRoomId: widget.chatRoomId,
        messageMap: messageMap,
      );
      messageTEController.clear();
    }
  }

  Widget ChatMessageList() {
    return Container(
      padding: EdgeInsets.only(bottom: 80),
      child: StreamBuilder<QuerySnapshot>(
        stream: chatMsgStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                      message:
                          snapshot.data.docs.elementAt(index).get("message"),
                      sentByMe:
                          (snapshot.data.docs.elementAt(index).get("sentBy") ==
                              Constants.myName),
                      timeStamp:
                          snapshot.data.docs.elementAt(index).get("timeStamp"),
                    );
                  },
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(widget.username),
        actions: [
          IconButton(onPressed: () => refreshChats(), icon: Icon(Icons.refresh))
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Colors.blueGrey,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageTEController,
                        decoration: customTextFieldDecoration("Message..."),
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      onPressed: () => sendMessage(),
                      icon: Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sentByMe;
  final String timeStamp;

  MessageTile({
    required this.message,
    required this.sentByMe,
    required this.timeStamp,
  });

  @override
  Widget build(BuildContext context) {
    int temp = int.parse(timeStamp);
    int hour = DateTime.fromMillisecondsSinceEpoch(temp).hour;
    int minute = DateTime.fromMillisecondsSinceEpoch(temp).minute;
    List<Widget> temp2 = [
      Text("$hour:$minute"),
      SizedBox(width: 20),
      Flexible(
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: sentByMe ? Colors.teal : Colors.grey[400],
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            message,
            style: TextStyle(),
            maxLines: 10,
          ),
        ),
      ),
    ];

    return Container(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: sentByMe ? temp2 : List.from(temp2.reversed),
      ),
    );
  }
}
