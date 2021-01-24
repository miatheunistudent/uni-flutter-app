/* ************************************************************************
 * FILE : adminInteraction.dart
 * DESC : Functions to update Firebase data related to strikes and reports
 * ************************************************************************
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unistudentapp/data/globals.dart';
import 'package:unistudentapp/utils/backend/userInteraction.dart';
import 'package:unistudentapp/utils/backend/feedInteraction.dart';


class AdminInteraction {

  static final CollectionReference users = FirebaseFirestore.instance.collection("Users");
  static final CollectionReference looking = FirebaseFirestore.instance.collection("Lookings");
  static final CollectionReference offering = FirebaseFirestore.instance.collection("Offerings");

  Future<void> addUserStrike(UserAccount user) async {
    await users.doc(user.id).update({STRIKES : FieldValue.increment(1)});
  }

  Future<void> removeUserStrike(UserAccount user) async {
    await users.doc(user.id).update({STRIKES : FieldValue.increment(-1)});
  }

  Future<void> addUserReport(UserAccount user) async {
    await users.doc(user.id).update({REPORTS : FieldValue.increment(1)});
  }

  Future<void> clearUserReports(UserAccount user) async {
    await users.doc(user.id).update({REPORTS : 0});
  }

  Future<void> addPostStrikeState(UserAccount user, Post post) async {
    user.strikesSnapshots.add({
      "isPost": true,
      "author": post.author,
      "category": post.category,
      "dateTimeStr": post.dateTimeStr,
      "description": post.description,
      "feedNum": post.feedNum,
      "title": post.title,
      "tags": post.tags.toArray(),
    });
    users.doc(user.id).update({STRIKES_SNAPSHOTS : user.strikesSnapshots});
  }

  Future<void> addProfileStrikeState(UserAccount user) async {
    user.strikesSnapshots.add({
      "isPost": false,
      "username": user.userName,
      "bio": user.bio,
      "avatar": {"color": user.avatarColor, "icon": user.avatarIcon},
      "skills": user.skills.toArray(),
    });
    users.doc(user.id).update({STRIKES_SNAPSHOTS : user.strikesSnapshots});
  }

  Future<void> removeStrike(UserAccount user, int strikeNum) async {
    user.strikesSnapshots.removeAt(strikeNum);
    users.doc(user.id).update({STRIKES_SNAPSHOTS : user.strikesSnapshots});
    removeUserStrike(user);
  }

  Future<void> reportPost(Post post, int feedNum) async { 
    feedNum == 0
      ? await looking.doc(post.id).update({REPORTS : FieldValue.increment(1)})
      : await offering.doc(post.id).update({REPORTS : FieldValue.increment(1)});
  }

  Future<void> clearPostReports(Post post, int feedNum) async { 
    feedNum == 0
      ? await looking.doc(post.id).update({REPORTS : 0})
      : await offering.doc(post.id).update({REPORTS : 0});
  }
}

