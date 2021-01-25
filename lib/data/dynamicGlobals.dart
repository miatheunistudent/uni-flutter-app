/* ************************************************************************
 * FILE : dynamicGlobals.dart
 * DESC : Classes used to load and return globals from backend
 * ************************************************************************
 */

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unistudentapp/data/globals.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:connectivity/connectivity.dart';

class DynamicGlobals {

  // Hold data
  static final DocumentReference appDataDoc
  = FirebaseFirestore.instance.collection("appData").doc(GLOBALS);
  Map<String, dynamic> globalAppData;

  // Global values
  Map<String, String> categoryData;
  Map<String, int> avatarColorData;
  List<String> postLabels;
  List<String> skillLabels;
  String termsOfService;
  String appDescription;
  String hashtag;

  // On first app run ever, stores in preferences
  Future<void> setup() async {
    if (!prefs.containsKey(CATEGORY_DATA))
      await prefs.setString(CATEGORY_DATA, json.encode({}));

    if (!prefs.containsKey(AVATAR_COLOR_DATA))
      await prefs.setString(AVATAR_COLOR_DATA, json.encode({}));

    if (!prefs.containsKey(POST_LABELS))
      await prefs.setString(POST_LABELS, json.encode([]));

    if (!prefs.containsKey(SKILL_LABELS))
      await prefs.setString(SKILL_LABELS, json.encode([]));

    if (!prefs.containsKey(TERMS_OF_SERVICE))
      await prefs.setString(TERMS_OF_SERVICE, json.encode(''));

    if (!prefs.containsKey(HASHTAG))
      await prefs.setString(HASHTAG, json.encode(''));
  }

  // Updates query data if missing and returns the object
  Future<dynamic> getAppData(dynamic object, String objectName, bool onlineOnly) async {

    // Returns if already laoded and not online only
    if (object != null && !onlineOnly)
      return object;

    try {

      // Check if offline
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none)
        throw ("offline");

      // Gets global app data -- will only work if online
      DocumentSnapshot snapshot = await appDataDoc
          .get(GetOptions(source: Source.server));
      this.globalAppData = snapshot.data();
    }
    catch(error) {

      // Error if online only
      if (onlineOnly)
        throw error;

      // Returns if object cached and currently offline
      return json.decode(prefs.getString(objectName));
    }

    return await getAppDataFromBackend(object, objectName);
  }

  // Loads from backend when online
  Future<dynamic> getAppDataFromBackend(dynamic object, String objectName) async {

    // Gets desired object from cached array
    dynamic tempObject = this.globalAppData[objectName];

    // Store in memory
    await prefs.setString(objectName, json.encode(tempObject));

    // Returns the newly created dynamic object
    return tempObject;
  }

  // Loads all global values
  Future<void> loadGlobals({bool online: false}) async {

    // Stores data on first run ever
    await setup();

    // Gets category data
    await getAppData(this.categoryData, CATEGORY_DATA, online)
        .then((dynamic data) {
      this.categoryData = {};
      data.forEach((key, value) => this.categoryData[key.toString()]
      = value.toString());
    });

    // Gets avatar color data
    await getAppData(this.avatarColorData, AVATAR_COLOR_DATA, online)
        .then((dynamic data) {
      this.avatarColorData = {};
      data.forEach((key, value) => this.avatarColorData[key.toString()]
      = int.parse(value.toString()));
    });

    // Gets post tag data
    await getAppData(this.postLabels, POST_LABELS, online)
        .then((dynamic data) {
      this.postLabels = [];
      data.forEach((value) => postLabels.add(value.toString()));
    });

    // Gets skill data
    await getAppData(this.skillLabels, SKILL_LABELS, online)
        .then((dynamic data) {
      this.skillLabels = [];
      data.forEach((value) => skillLabels.add(value.toString()));
    });

    // Gets terms of service data
    await getAppData(this.termsOfService, TERMS_OF_SERVICE, online)
        .then((dynamic data) {
      termsOfService = data.toString();
    });

    // Gets app description data
    await getAppData(this.appDescription, APP_DESCRIPTION, online)
        .then((dynamic data) {
      appDescription = data.toString();
    });

    // Gets hashtag data
    await getAppData(this.hashtag, HASHTAG, online)
        .then((dynamic data) {
      hashtag = data.toString();
    });
  }
}

// Terms of service String
String get tos => dynamicGlobals.termsOfService;

// App description String
String get appDescription => dynamicGlobals.appDescription;


// Colors for avatars
Map<String, Color> _avatarColors;
Map<String, Color> get avatarColors {

  if (_avatarColors == null) {
    _avatarColors = dynamicGlobals.avatarColorData
        .map((key, value) => MapEntry(key, Color(value)));
  }

  return _avatarColors;
}

// Creates a sorted list of colors
List<String> _avatarColorNames;
List<String> get avatarColorNames {

  if (_avatarColorNames == null) {
    _avatarColorNames = [];
    avatarColors.forEach((name, color) => _avatarColorNames.add(name));
    _avatarColorNames.sort((a, b) => HSVColor.fromColor(avatarColors[a]).hue
        .compareTo(HSVColor.fromColor(avatarColors[b]).hue));
  }

  return _avatarColorNames;
}

// Category icons
Map<String, String> _categoryData;
Map<String, String> get categoryData {

  if (_categoryData == null) {
    _categoryData = dynamicGlobals.categoryData
      ..addAll({OTHER: 'progressQuestion'});
  }

  return _categoryData;
}

// Category names list
List<String> _categoryOptionsList;
List<String> get categoryOptionsList {

  if (_categoryOptionsList == null) {
    _categoryOptionsList = categoryData.keys.toList()..sort()..remove(OTHER)..add(OTHER);
  }

  return _categoryOptionsList;
}

// Category names numbered
Map<int, String> _categoryOptions;
Map<int, String> get categoryOptions {

  if (_categoryOptions == null) {
    int categoryOptionsIndex = 0;
    _categoryOptions = Map.fromIterable(categoryOptionsList, key: (key) =>
    categoryOptionsIndex++);
  }

  return _categoryOptions;
}

// Different types of icons for categories
Map<String, IconData> _skillIcons;
Map<String, IconData> get skillIcons {

  if (_skillIcons == null) {
    _skillIcons = categoryData.map((key, value) =>
        MapEntry(key, MdiIcons.fromString(value)));
  }

  return _skillIcons;
}

Map<String, Widget> _categoryIcons;
Map<String, Widget> get categoryIcons{

  if (_categoryIcons == null){
    _categoryIcons = skillIcons.map((key, value) =>
        MapEntry(key, Icon(value, color: Colors.white, size: 24)));
  }

  return _categoryIcons;
}

Map<String, Widget> _blackCategoryIcons;
Map<String, Widget> get blackCategoryIcons{

  if (_blackCategoryIcons == null){
    _blackCategoryIcons = skillIcons.map((key, value) =>
        MapEntry(key, Icon(value, color: Colors.black, size: 24)));
  }

  return _blackCategoryIcons;
}

// Strings for post tags
List<String> get postLabels => dynamicGlobals.postLabels;

// Strings for skill tags
List<String> _skillLabels;
List<String> get skillLabels{

  if (_skillLabels == null) {
    _skillLabels = dynamicGlobals.skillLabels..sort()..add(OTHER);
  }

  return _skillLabels;
}