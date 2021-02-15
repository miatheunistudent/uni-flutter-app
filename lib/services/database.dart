import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniapp/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userDataCollection =
      FirebaseFirestore.instance.collection('UserData');

  //update user data
  Future updateUserData(
      String firstName, String lastName, String phoneNumber, String uni) async {
    return await userDataCollection.doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'uni': uni,
    });
  }

  //Update user interests
  Future updateUserInterests(List<String> interests) async {
    return await userDataCollection.doc(uid).set({'interests': interests});
  }
}
