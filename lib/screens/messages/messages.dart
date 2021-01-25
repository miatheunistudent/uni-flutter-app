/* ************************************************************************
 * FILE : messages.dart
 * DESC : Creates messages feed.
 * ************************************************************************
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unistudentapp/data/globalWidgets.dart';
import 'package:unistudentapp/data/globals.dart';
import 'package:unistudentapp/utils/backend/chatInteraction.dart';
import 'package:unistudentapp/utils/navigation.dart';

class MessagePage extends StatelessWidget {

  final Stream userChats = ChatInteraction().getUserChats();

  StreamBuilder messagesPage() {

    // Builds chat asynchronously
    return StreamBuilder(
        stream: userChats,
        builder: (context, snapshot){
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          else if (snapshot.data.size == 0) return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("No Messages", style: TextStyle(fontSize: 22)),
                    Text("Start chatting with someone via their listings!", style: TextStyle(fontSize: 13)),
                  ]
              )
          );

          // Get data from snapshot
          List<QueryDocumentSnapshot> builderData = snapshot.data.docs;

          // Build a list of chats
          return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: builderData.length,
              itemBuilder: ((BuildContext buildContext, int index) {

                return MessageCard(builderData[index], key: UniqueKey());
              })
          );
        }
    );
  }

  // Builds widget
  @override
  Widget build(BuildContext context) {
    return messagesPage();
  }
}

class MessageCard extends StatefulWidget {
  final QueryDocumentSnapshot snapshot;

  @override
  MessageCard(this.snapshot, {Key key}) : super(key: key);
  MessageCardState createState() => new MessageCardState();
}

// Dynamic login data
class MessageCardState extends State<MessageCard> {

  Chat chat;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    loadData();


  }


  void setMyState() {
    setState(() {});
  }

  // Grabs necessary content
  Future<void> loadData() async {

    chat = await Chat().fromSnapshot(this.widget.snapshot);

    if (this.mounted)
      setState(() {loaded = true;});
  }

  // Builds widget
  @override
  Widget build(BuildContext context) {
    if (!loaded) return Center(child: CircularProgressIndicator());

    // Creates tile
    return InkWell(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            child: Row(
                children: [

                  // Avatar
                  chat.otherUser.userAvatar(
                      radius: 45,
                      padding: EdgeInsets.only(right: 16.5)
                  ),
                  Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            children: <Widget>[

                              // Username
                              Text(
                                chat.otherUser.userName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),

                              Expanded(child: Container()),

                              // Date of most recent message
                              Text(
                                  formattedTime(chat.dateTimeStr),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500]
                                  )
                              ),
                            ]
                        ),

                        // Text from most recent message
                        Text(
                            chat.lastMessage,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800]
                            )
                        )
                      ]
                  ))
                ]
            )
        ),

        // Navigates to chat
        onTap: () => locator<NavigationService>().navigateWithParameters('/chat', chat),
        onLongPress: () => showDialog(
            context: context,
            builder: (BuildContext context) => generateDeletePopUp(chat.id)
        )
    );
  }
}