/* ************************************************************************
 * FILE : globals.dart
 * DESC : Stores the constant values for the application.
 * ************************************************************************
 */

import 'package:algolia/algolia.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:unistudentapp/data/dynamicGlobals.dart';
import 'package:unistudentapp/utils/backend/adminInteraction.dart';
import 'package:unistudentapp/utils/backend/apiCredentials.dart';
import 'package:unistudentapp/utils/backend/feedInteraction.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

// Accessors
SharedPreferences prefs;
Key postKey = UniqueKey();
APICredentials apiCredentials = APICredentials();
AdminInteraction adminAuth = AdminInteraction();
bool newAccount = false;
Algolia algoliaInstance;
FocusNode lookingSearchController = FocusNode();
FocusNode offeringSearchController = FocusNode();
DynamicGlobals dynamicGlobals = DynamicGlobals();
PackageInfo packageInfo;

// Reference to photos storage
final Reference imagesStorage = FirebaseStorage.instance.ref().child(IMAGES);

// Constants
const PRIMARY_COLOR = Color(0xFF0c2771);
const SECONDARY_COLOR = Color(0xFFa6b4db);
const SETUP_SPACING = EdgeInsets.only(left: 24.0, right: 24.0, bottom: 120.0);
const STANDARD_SPACING = EdgeInsets.only(top: 48.0, left: 24.0, right: 24.0, bottom: 80.0);

// Strings for backend interaction
const TITLE = 'title';
const DESCRIPTION = 'description';
const CATEGORY = 'category';
const AUTHOR = 'author';
const DATETIME = 'dateTime';
const DATETIME_STR = 'dateTimeStr';
const TAGS = 'tags';
const UID = 'uid';
const UIDS = 'uids';
const CHATS = 'chats';
const UNAME = 'username';
const FEEDNUM = 'feedNum';
const LIKE_POST = 'likePost';
const UNLIKE_POST = 'unlikePost';
const BIO = 'bio';
const SKILLS = 'skills';
const PHOTOS = 'photos';
const NEW = 'new';
const AVATAR = 'avatar';
const COLOR = 'color';
const ICON = 'icon';
const INDEX_ON = '.indexOn';
const CATEGORY_DATA = 'categoryData';
const AVATAR_COLOR_DATA = 'avatarColorData';
const POST_LABELS = 'postLabels';
const SKILL_LABELS = 'skill_labels';
const TEXT = 'text';
const LAST_MESSAGE = 'lastMessage';
const EXPIRES = 'expires';
const USER_LIKES = 'likes';
const GLOBALS = 'globals';
const TERMS_OF_SERVICE = 'termsOfService';
const APP_DESCRIPTION = 'appDescription';
const HASHTAG = 'hashtag';
const IMAGES = 'images';
const ADMIN = 'admin';
const STRIKES = 'strikes';
const REPORTS = 'reports';
const STRIKES_SNAPSHOTS = 'strikesSnapshots';

// Strings repreated in-app
const CATEGORY_PROMPT = "Category";
const LIGHT = 'Light Mode';
const DARK ='Dark Mode';
const SYSTEM = 'System';
const CURRENT_THEME = 'current_theme';
const LOOKING = 'Looking';
const OFFERING = 'Offering';
const OTHER = 'Other';

// Screens (for snackbar)
const HOME = 'home';
const LOGIN = 'login';
const SKILLTAGS = 'skill_tags';
const CREATE_ACCOUNT = 'create_account';
const FORGOT_PASSWORD = 'forgot_password';
const CHANGE_PASSWORD = 'change_password';
const DELETE_ACCOUNT = 'delete_account';
const CHAT = 'chat';

// Theming values
ThemeData currentTheme = ThemeData();

// Rounded corners on bottom sheet
const RoundedRectangleBorder BOTTOM_SHEET = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
);

// Rounded corners on search bar, messaging bar
const BorderRadius VERY_ROUND = BorderRadius.all(Radius.circular(40));

// SHadowless appbar for setup
AppBar setupAppBar = AppBar(elevation: 0, );

// Theme modes names
const List<String> themeNames = [
  LIGHT,
  DARK,
  SYSTEM
];

// Twitter constants
const ID = 'id';
const USER = 'user';
const NAME = 'name';
const SCREENNAME = 'screen_name';
const PROFILEPIC = 'profile_image_url_https';
const FULLTEXT = 'full_text';
const ENTITIES = 'entities';
const CREATEDDATE = 'created_at';
const MEDIA = 'media';
const MEDIASRC = 'media_url_https';
const LIKES = 'favorite_count';
const RETWEET = 'retweet_count';
const STATUSES = 'statuses';


// Gets string name of feed
String feedName(dynamic number) {
  int feedNum = int.parse(number.toString());
  return feedNum == 0
      ? LOOKING
      : OFFERING;
}

// Gets int num of feed
int feedNum(String name) {
  return name == LOOKING
      ? 0
      : 1;
}

// Gets feed with name
FeedInteraction getFeed(dynamic feedNameNum) {
  return feedNameNum == LOOKING || feedNameNum == 0
      ? lookingFeed
      : offeringFeed;
}