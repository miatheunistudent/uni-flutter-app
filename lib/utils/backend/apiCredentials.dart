/* ************************************************************************
 * FILE : apiCredentials.dart
 * DESC : Gets API credentials from database
 * ************************************************************************
 */

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class APICredentials {

  // Used to cache credentials
  TwitterCredential twitterCred;
  Algolia algoliaInstance;

  // Gets Twitter credentials from Firebase backend
  Future<TwitterCredential> getTwitterCredfromFb() async {
    if (twitterCred == null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("privateAppData")
        .doc("twitterAuthentication").get();
      twitterCred = TwitterCredential().fromJson(userDoc.data());
    }

    return twitterCred;
  }

  // Gets Algolia credentials from Firebase backend
  Future<Algolia> getAlgoliaCredfromFb() async {

    // Checks for cached data
    if (algoliaInstance == null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("privateAppData")
        .doc("algoliaAuthentication").get();

      // Builds instance with Api Key
      algoliaInstance =  Algolia.init(
        applicationId: userDoc.data()['app_id'],
        apiKey: userDoc.data()['api_key']
      );
    }

    return algoliaInstance;
  }
}

// Builds a class to store Twitter Credential
class TwitterCredential {
  String apiKey;
  String apiKeySecret;
  String accessToken;
  String accessTokenSecret;

  // Builds from JSON data
  TwitterCredential fromJson(Map<String, dynamic> userData) {
    this.apiKey = userData['api_key'];
    this.apiKeySecret = userData['api_keysecret'];
    this.accessToken = userData['access_token'];
    this.accessTokenSecret = userData['access_tokensecret'];
    return this;
  }
}
