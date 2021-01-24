/* ************************************************************************
 * FILE : feedInteraction.dart
 * DESC : Handles interaction with feed collections in the database.
 * ************************************************************************
 */

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unistudentapp/data/dynamicGlobals.dart';
import 'package:unistudentapp/data/globals.dart';
import 'package:unistudentapp/data/tags.dart';
import 'package:unistudentapp/utils/backend/accountManagement.dart';
import 'package:unistudentapp/utils/dateFormatting.dart';
import 'package:async/async.dart';
import 'package:rxdart/rxdart.dart';

// Two different feeds from which to pull / to which to push
final lookingFeed =
    FeedInteraction("Lookings");
final offeringFeed =
    FeedInteraction("Offerings");
final userFeed =
    FeedInteraction("Users");

// Used to interact with a particular feed
class FeedInteraction {
  final String feedName;

  // Stores the regular (Firebase) and search (Algolia) feeds
  CollectionReference feed;
  AlgoliaIndexReference searchFeed;
  FeedInteraction(this.feedName) {
    feed = FirebaseFirestore.instance.collection(feedName);
    searchFeed = algoliaInstance.instance.index(feedName);
  }

  // Adds a provided post to a feed, generating JSON data from Post
  Future<void> postToFeed(Post post) async {
    Map<String, dynamic> postData = post.createJson()..addAll({USER_LIKES: [], REPORTS: 0});
    await feed.add(postData);
  }

 // Loads single post from a feed, creating Post from JSON data
  Future<Post> loadSinglePost(String postId) async {
    DocumentSnapshot postDoc;
    try {
      postDoc = await feed.doc(postId).get();
    }
    
    // Errors
    catch(error) { return null; }
    if (postDoc.exists == false) return null;
    
    return Post().fromJson(postDoc.id, postDoc.data());
  }

  // Likes a post for the current user in firebase
  Future<void> likePost(String postId) async {
    String uid = AccountManagement().currentUserId();
    await feed.doc(postId).update({USER_LIKES : FieldValue.arrayUnion([uid])});
  }

  // Unlikes a post and update the map in firebase
  Future<void> unlikePost(String postId) async {
    String uid = AccountManagement().currentUserId();
    await feed.doc(postId).update({USER_LIKES : FieldValue.arrayRemove([uid])});
  }

  // Deletes a post
  Future<void> deletePost(String postId) async {
    await feed.doc(postId).delete();
  }

  // Updates a post
  Future<void> updatePost(Post post) async {
    await feed.doc(post.id).update(post.updateJson());
  }

  // Gets snapshot with current feed data
  Future<QuerySnapshot> getSnapshot(bool online) {
    return feed.orderBy(DATETIME, descending: true).get(
        GetOptions(source: online ? Source.server : Source.serverAndCache));
  }

  // Gets stream with current feed data
  Stream<QuerySnapshot> getFilteredStream(String field, {dynamic isEqualTo, dynamic arrayContains}) {
    return feed.where(field, isEqualTo: isEqualTo, arrayContains: arrayContains)
      .orderBy(DATETIME, descending: true).snapshots().asBroadcastStream();
  }

  // Runs search on Algolia Index Reference
  Future<AlgoliaQuerySnapshot> getSearchSnapshot(String searchString) {
    return searchFeed.search(searchString).getObjects();
  }

  // Queries a feed based on array or equality
  Query queryFeed(String field, {dynamic isEqualTo, dynamic arrayContains}) {
    return feed.where(field, isEqualTo: isEqualTo, arrayContains: arrayContains);
  }

  // Filters where field == value
  Future<QuerySnapshot> getFilteredSnapshot(String field, String value) {
    return queryFeed(field, isEqualTo: value).get();
  }

  // Filters where strikes > 0
  Future<QuerySnapshot> getSnapshotWithReports() {
    return feed.where(REPORTS, isGreaterThan: 0).orderBy(REPORTS, descending: true).get();
  }
}

// Post object and attributes
class Post {
  String id;
  String title;
  String description;
  String category;
  String author;
  FieldValue dateTime = FieldValue.serverTimestamp();
  DateTime expires;
  String dateTimeStr;
  PostTags tags;
  int feedNum;
  int reports;
  bool liked = false;

  Post(
    {this.id,
    this.title,
    this.description,
    this.category,
    this.author,
    this.tags,
    this.feedNum,
    this.reports,
    int monthsUntilExpiration = 1}) {

      // Creation date
      dateTimeStr = DateTime.now().toUtc().toString();

      // Expiration date
      this.expires = DateTime.now().toUtc()
        .add(Duration(days: 30 * monthsUntilExpiration));
  }

  // Encode new post as JSON data
  Map<String, dynamic> createJson() {
    return {
      TITLE: this.title,
      DESCRIPTION: this.description,
      CATEGORY: this.category,
      AUTHOR: this.author,
      TAGS: this.tags.toArray(),
      DATETIME: this.dateTime,
      DATETIME_STR: this.dateTimeStr,
      FEEDNUM: this.feedNum,
      EXPIRES: this.expires
    };
  }

  // Encode updated post as JSON data
  Map<String, dynamic> updateJson() {
    return {
      TITLE: this.title,
      DESCRIPTION: this.description,
      CATEGORY: this.category,
      TAGS: this.tags.toArray()
    };
  }

  // Builds a post from JSON data
  Post fromJson(String id, Map<String, dynamic> postData) {
    var tagsData = postData[TAGS];

    this.id = id;
    this.title = postData[TITLE];
    this.description = postData[DESCRIPTION];
    this.category = postData[CATEGORY];
    this.author = postData[AUTHOR];
    this.dateTimeStr = localize(postData[DATETIME_STR]);
    this.tags = PostTags().fromArray(tagsData);
    this.feedNum = postData[FEEDNUM];
    this.reports = postData[REPORTS];
    this.liked = postData[USER_LIKES].contains(AccountManagement().currentUserId());

    // Ensures categories not removed in future
    if (!categoryOptionsList.contains(this.category))
      this.category = OTHER;

    return this;
  }
}

// Tags that help characterize a post in terms of project length/location
class PostTags extends UniTags {
  PostTags() {
    this.tagLabels = postLabels;
    this.generateTagValues();
  }
}

// Gets combined snapshot of all posts liked by user
Stream<CustomQuerySnapshot> getLikedSnapshot() {

  // Current uid
  String uid = AccountManagement().currentUserId();

  // Looking
  Stream<QuerySnapshot> lookingStream = 
    LazyStream(() => lookingFeed.queryFeed(USER_LIKES, arrayContains: uid).snapshots());

  // Offering
  Stream<QuerySnapshot> offeringStream =
    LazyStream(() => offeringFeed.queryFeed(USER_LIKES, arrayContains: uid).snapshots());

  // Combines streams
  return Rx.combineLatest2(lookingStream, offeringStream, (lookingSnapshot, offeringSnapshot) {
    List<QueryDocumentSnapshot> docs = (lookingSnapshot.docs + offeringSnapshot.docs)
      ..sort((QueryDocumentSnapshot a, QueryDocumentSnapshot b) {
        int order;
        order = b.data()[DATETIME_STR].compareTo(a.data()[DATETIME_STR]);
        return order;
      });
      return CustomQuerySnapshot(docs);
  }).asBroadcastStream();
}

class CustomQuerySnapshot {
  List<QueryDocumentSnapshot> docs;
  CustomQuerySnapshot(this.docs);
}