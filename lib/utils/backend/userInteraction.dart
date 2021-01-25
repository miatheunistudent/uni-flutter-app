/* ************************************************************************
 * FILE : userInteraction.dart
 * DESC : Handles interaction with user collection in the database.
 * ************************************************************************
 */

import 'dart:async';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:unistudentapp/data/dynamicGlobals.dart';
import 'package:unistudentapp/data/globals.dart';
import 'package:unistudentapp/data/tags.dart';
import 'package:unistudentapp/utils/backend/accountManagement.dart';

class UserInteraction {
  // Table with user data
  static final CollectionReference users = FirebaseFirestore.instance.collection("Users");

  // Loads single user from the backend, creating UserAccount from JSON data
  Future<UserAccount> loadSingleUser(String userId) async {
    DocumentSnapshot userDoc = await users.doc(userId).get();
    return UserAccount().fromJson(userDoc.data(), userId);
  }

  // Loads current user from the backend, creating UserAccount from JSON data
  Future<UserAccount> loadCurrentUser() async {
    String userId = FirebaseAuth.instance.currentUser.uid;
    DocumentSnapshot userDoc = await users.doc(userId).get();
    return UserAccount().fromJson(userDoc.data(), userId);
  }

  // Loads one user from abckend to check NEW bool
  Future<bool> isUserNew(String uid) async {
    DocumentSnapshot userEntry = await users.doc(uid).get();
    return userEntry.data()[NEW];
  }

  // Updates user in Firebase, generating JSON data from UserAccount
  Future<void> updateUser(UserAccount user) async {
    Map<String, dynamic> userData = user.toJson();
    String uid = FirebaseAuth.instance.currentUser.uid;
    await user.uploadPhotos();
    await users.doc(uid).update(userData);
  }

  // Checks if a username is already in use
  Future<bool> usernameUsed(String username) async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    String myUsername = '';
    if (! await isUserNew(uid)) {
      UserAccount account = await loadCurrentUser();
      myUsername = account.userName;
    }
    QuerySnapshot doc = await users.where(UNAME, isEqualTo: username).get();
    return doc.docs.isNotEmpty && doc.docs.first.data()[UNAME] != myUsername;
  }
}

class UserAccount {
  String id = '';
  String userName = '';
  SkillTags skills = SkillTags();
  String bio = '';
  String avatarColor = avatarColors.keys.first;
  String avatarIcon = skillIcons.keys.first;
  bool admin;
  int strikes = 0;
  int reports = 0;
  List<dynamic> strikesSnapshots = [];

  List<String> photoPaths = [];
  List<ImageProvider<Object>> photos;
  List<MapEntry<String, Uint8List>> newPhotoReps = [];
  List<String> oldPhotoLocs = [];

  // Produces an avatar for the user
  Widget userAvatar({double radius = 180.0, monochrome = false,
    EdgeInsets padding = const EdgeInsets.all(0)}) {
  
    return Container(
      padding: padding,
      child: Container(
        height: radius,
        width: radius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: monochrome
            ? Colors.white
            : avatarColors[this.avatarColor],
        ),
        child: Icon(
          skillIcons[this.avatarIcon],
          color: monochrome
            ? PRIMARY_COLOR
            : Colors.white,
          size: radius * 0.475
        )
      )
    );
  }

  // Adds file to photos
  Future<void> addPhoto(String photoLoc, Uint8List encodedPhoto) async {
    this.photoPaths.add(photoLoc);
    this.photos.add(MemoryImage(encodedPhoto));
    this.newPhotoReps.add(MapEntry(photoLoc, encodedPhoto));
  }

  // Remove file from photos
  Future<void> removePhoto(int photoIndex) async {

    // Determines whether photo is in cloud
    bool inCloud = true;
    if (this.newPhotoReps.indexWhere((newPhotoRep) =>
      newPhotoRep.key == this.photoPaths[photoIndex]) >= 0)
        inCloud = false;

    // Queue for removal from cloud
    if (inCloud)
      oldPhotoLocs.add(this.photoPaths[photoIndex]);

    // Remove from upload queue
    if (!inCloud)
      this.newPhotoReps.removeWhere((newPhotoRep) =>
        newPhotoRep.key == this.photoPaths[photoIndex]);

    // Remove locally
    this.photoPaths.removeAt(photoIndex);
    this.photos.removeAt(photoIndex);
  }

  Map<String, dynamic> toJson() {

    return {
      UNAME: this.userName,
      BIO: this.bio,
      SKILLS: this.skills.toArray(),
      AVATAR: {COLOR: this.avatarColor, ICON: this.avatarIcon},
      PHOTOS: this.photoPaths,
      NEW: false
    };
  }

  // Builds from JSON data
  UserAccount fromJson(Map<String, dynamic> userData, String userId) {

    this.id = userId;
    this.userName = userData[UNAME];
    this.skills = SkillTags().fromArray(userData[SKILLS]);
    this.bio = userData[BIO];
    this.avatarColor = userData[AVATAR][COLOR];
    this.avatarIcon = userData[AVATAR][ICON];
    this.strikes = userData[STRIKES];
    this.admin = userData[ADMIN];
    this.reports = userData[REPORTS];
    this.strikesSnapshots = userData[STRIKES_SNAPSHOTS];
    userData[PHOTOS].forEach((photoPath) =>
      this.photoPaths.add(photoPath.toString()));

    return this;
  }

  UserAccount clone() {
    UserAccount clonedAccount = UserAccount();
    clonedAccount.id = this.id;
    clonedAccount.userName = this.userName;
    clonedAccount.skills = this.skills.clone();
    clonedAccount.bio = this.bio;
    clonedAccount.avatarColor = this.avatarColor;
    clonedAccount.avatarIcon = this.avatarIcon;
    clonedAccount.photoPaths = List<String>.from(this.photoPaths);
    clonedAccount.strikes = this.strikes;
    clonedAccount.admin = this.admin;
    clonedAccount.reports = this.reports;
    clonedAccount.strikesSnapshots = this.strikesSnapshots;


    return clonedAccount;
  }

  Future<void> loadPhotos() async {

    List<ImageProvider<Object>> tempPhotoData = [];
    List<String> failedPhotoPaths = [];

    // Gets photos from backend
    for (String photoPath in this.photoPaths) {

      ImageProvider<Object> singlePhoto;

      // Store photo
      try {
        singlePhoto = CachedNetworkImageProvider(
          photoPath,
          scale: 1.0
        );
      }
      catch(error) {failedPhotoPaths.add(photoPath);}

      // Save photo
      if (singlePhoto != null)
        tempPhotoData.add(singlePhoto);
    }

    // Removes failed photos from list
    for (String failedPhotoPath in failedPhotoPaths) {
      this.photoPaths.removeWhere((String photoPath) =>
        photoPath == failedPhotoPath);
    }

    // Stores photos
    this.photos = tempPhotoData;
  }

  Future<void> uploadPhotos() async {

    // Remove old photos from cloud
    for (String photoLoc in this.oldPhotoLocs)
      runSafe(() async {
        FirebaseStorage.instance
        .refFromURL(photoLoc)
        .delete();
      });

    // If no changes
    if(this.photos == null)
      return;

    // Update each photo
    for (MapEntry<String, Uint8List> newPhotoRep in this.newPhotoReps) {
       TaskSnapshot taskSnapshot = await imagesStorage
      .child(AccountManagement().currentUserId())
      .child(newPhotoRep.key)
      .putData(newPhotoRep.value);

      int relativeLoc =
        this.photoPaths.indexWhere((String loc) => loc == newPhotoRep.key);
      if (relativeLoc >= 0)
        this.photoPaths[relativeLoc] = await taskSnapshot.ref.getDownloadURL();
    }

    this.newPhotoReps = [];
  }
}

class SkillTags extends UniTags {
  SkillTags() {
    this.tagLabels = skillLabels;
    this.generateTagValues();
  }

  // Clones all data
  SkillTags clone() {
    SkillTags clonedTags = SkillTags();
    clonedTags.tagValues = Map<String, bool>.from(this.tagValues);
    return clonedTags;
  }
}

// USED FOR BUG FIX

// CITE : https://github.com/flutter/flutter/issues/18547
// DESC : Fixes error-catching bug currently present in storage module
Future<T> runSafe<T>(Future<T> Function() func) {
  final onDone = Completer<T>();
  runZoned(
    func,
    onError: (e, s) {
      if (!onDone.isCompleted) {
        onDone.completeError(e, s as StackTrace);
      }
    },
  ).then((result) {
    if (!onDone.isCompleted) {
      onDone.complete(result);
    }
  });
  return onDone.future;
}