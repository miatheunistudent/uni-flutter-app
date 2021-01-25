/* ************************************************************************
 * FILE : chatInteraction.dart
 * DESC : Handles interaction with accounts in the database.
 * ************************************************************************
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unistudentapp/data/globals.dart';
import 'package:unistudentapp/utils/backend/accountManagement.dart';
import 'package:unistudentapp/utils/backend/userInteraction.dart';
import 'package:unistudentapp/utils/dateFormatting.dart';

class ChatInteraction {

  CollectionReference messagesCollection = FirebaseFirestore.instance.collection('Messages');

  Stream<QuerySnapshot> getChatMessages(DocumentReference chatReference) {
    return chatReference
      .collection(CHATS)
      .orderBy(DATETIME, descending: true)
      .snapshots();
  }

  void addMessage(String chatID, ChatMessage chatMessage){
    messagesCollection
      .doc(chatID)
      .collection("chats")
      .add(chatMessage.toJson());
  }

  Future<void> deleteChat(String chatID) async {
    await messagesCollection
      .doc(chatID)
      .delete();
  }

  Stream<QuerySnapshot> getUserChats() {
    String uid = AccountManagement().currentUserId();
    return messagesCollection
      .where(UIDS, arrayContains: uid)
      .orderBy(DATETIME, descending: true)
      .snapshots();
  }

  Future<Chat> newChat(String otherUserId) async {
    
    // Gets current user's id
    String uid = AccountManagement().currentUserId();

    // Looks for exisitng chat
    QuerySnapshot existingChat;

    // First chat order
    existingChat = await messagesCollection
      .where(UIDS, isEqualTo: [uid, otherUserId]).get();
    if (existingChat.docs.isNotEmpty)
      return Chat().fromSnapshot(existingChat.docs.first);

    // Second chat order
    existingChat = await messagesCollection
      .where(UIDS, isEqualTo: [otherUserId, uid]).get();
    if (existingChat.docs.isNotEmpty)
      return Chat().fromSnapshot(existingChat.docs.first);
    
    // Creates a chat using the two user's ids
    DocumentReference chatReference =
      await messagesCollection.add(
        Chat(uids: [uid, otherUserId]).toJson()
      );

    // Returns chat object
    return Chat().fromSnapshot(await chatReference.get());
  }
}

class Chat {
  Stream<QuerySnapshot> chatStream;
  List<String> uids;
  UserAccount otherUser;
  String id;
  String lastMessage;
  String dateTimeStr;
  dynamic dateTime;

  Chat({this.uids});

  // Creates a chat from a document reference
  Future<Chat> fromSnapshot(DocumentSnapshot chatDoc) async {

    // Store chats
    this.chatStream = ChatInteraction().getChatMessages(chatDoc.reference);

    // Stores chat strings
    this.uids = chatDoc.data()[UID];
    this.id = chatDoc.id;
    this.dateTimeStr = localize(chatDoc.data()[DATETIME_STR]);
    this.lastMessage = chatDoc.data()[LAST_MESSAGE];

    // Gets other userId
    String otherUserId;
    if (chatDoc.data()[UIDS][0] == AccountManagement().currentUserId())
      otherUserId = chatDoc.data()[UIDS][1];
    else
      otherUserId = chatDoc.data()[UIDS][0];

    // Store other user
    this.otherUser = await UserInteraction().loadSingleUser(otherUserId);

    return this;
  }

  // Encode chat as JSON data
  Map<String, dynamic> toJson() {
    return {
      UIDS: this.uids
    };
  }
}

class ChatMessage {
  String author = '';
  String text = '';
  dynamic dateTime = FieldValue.serverTimestamp();
  String dateTimeStr = '';

  ChatMessage({this.text, this.author}) {
    dateTimeStr = DateTime.now().toUtc().toString();
  }

  // Encode message as JSON data
  Map<String, dynamic> toJson() {
    return {
      AUTHOR: this.author,
      TEXT: this.text,
      DATETIME: this.dateTime,
      DATETIME_STR: this.dateTimeStr,
    };
  }

  // Builds a message from JSON data
  ChatMessage fromJson(String id, Map<String, dynamic> messageData) {

    this.author = messageData[AUTHOR];
    this.text = messageData[TEXT];
    this.dateTime = messageData[DATETIME];
    this.dateTimeStr = localize(messageData[DATETIME_STR]);

    return this;
  }

}

// Formats time on messages
String formattedTime(dateTime) {
  String now = dateTime.substring(11,16);
  int hours = int.parse(now.substring(0,2));
  if (hours > 12) {
    return (hours - 12).toString().padLeft(2, '0') + ":" + now.substring(3) + "PM";
  }
  else{
    if(hours == 12) {
      return hours.toString().padLeft(2, '0') +  ":" + now.substring(3) + "PM";
    }
    if(hours == 0) {
      return (hours + 12).toString().padLeft(2, '0') +  ":" + now.substring(3) + "AM";
    }
    return hours.toString().padLeft(2, '0') +  ":" + now.substring(3) + "AM";
  }
}