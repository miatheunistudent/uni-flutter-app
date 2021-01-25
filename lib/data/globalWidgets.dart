/* ************************************************************************
 * FILE : globalWidgets.dart
 * DESC : Widgets used in multiple files throughout application.
 * ************************************************************************
 */

import 'package:flutter/material.dart';
import 'package:unistudentapp/data/globals.dart';
import 'package:unistudentapp/data/tags.dart';
import 'package:unistudentapp/utils/backend/chatInteraction.dart';
import 'package:unistudentapp/utils/backend/feedInteraction.dart';
import 'package:unistudentapp/utils/backend/userInteraction.dart';
import 'package:unistudentapp/utils/navigation.dart';
import 'package:unistudentapp/utils/backend/adminInteraction.dart';


/* ****************
 * ***** LOGO *****
 * ****************/

// App logo.
Image logo({double size = 160.0, bool showText = true}) {
  return Image.asset(
      showText ? 'assets/logo.png' : 'assets/logo_no_text.png',
      fit: BoxFit.contain,
      height: size
  );
}


/* ****************
 * **** ERRORS ****
 * ****************/

// Error snackbar
Map<String, GlobalKey<ScaffoldState>> snackbarKeys = {
  HOME: GlobalKey<ScaffoldState>(),
  LOGIN: GlobalKey<ScaffoldState>(),
  SKILLTAGS: GlobalKey<ScaffoldState>(),
  FORGOT_PASSWORD: GlobalKey<ScaffoldState>(),
  CREATE_ACCOUNT: GlobalKey<ScaffoldState>(),
  CHANGE_PASSWORD: GlobalKey<ScaffoldState>(),
  DELETE_ACCOUNT: GlobalKey<ScaffoldState>(),
  CHAT: GlobalKey<ScaffoldState>()
};

showSnackBar(String screen, String message) {
  snackbarKeys[screen]
      .currentState
      .showSnackBar(SnackBar(content: Text(message)));
}

// Returns true if the item is question is a listing, false if not (this
// means it's a message)
listingOrMessage(int feedNum) {
  if(feedNum != null) return true;
  return false;
}

/* ****************
 * **** POPUPS ****
 * ****************/

// Generates popup that asks the user if they want to delete doc at id
// Refreshes feed if number provided
AlertDialog generateDeletePopUp(String id, {int feedNum, int dialogsBelow = 0}) {
  return AlertDialog(
    title: const Text("Confirm Delete"),

    // Messages for deleting post/chat
    content: listingOrMessage(feedNum)
        ? Text("Do you want to delete this post?")
        : Text("Do you want to delete this chat? This will also delete the chat for the other user and is nonreversible."),

    actions: <Widget>[
      FlatButton(
        onPressed: () => locator<NavigationService>().pop(num: dialogsBelow + 1),
        child: const Text("No"),
      ),

      FlatButton(
          onPressed: () async {

            // Delete post and refresh feed
            if (feedNum != null) {
              feedNum == 0
                  ? lookingFeed.deletePost(id)
                  : offeringFeed.deletePost(id);
            }

            // Remove message
            else ChatInteraction().deleteChat(id);

            // Remove dialog
            locator<NavigationService>().pop(num: listingOrMessage(feedNum) ? 2 : 1);
          },
          child: const Text("Yes")
      ),
    ],
  );
}

AlertDialog generateReportUserPopUp(UserAccount user) {
  return AlertDialog(
    title: const Text("Report User"),

    // Messages for deleting post/chat
    content: Text("Do you want to report this user?"),

    actions: <Widget>[
      FlatButton(
        onPressed: () => locator<NavigationService>().pop(),
        child: const Text("No"),
      ),
      FlatButton(
          onPressed: () async {
            AdminInteraction().addUserReport(user);
            locator<NavigationService>().pop();
          },
          child: const Text("Yes")
      ),
    ],
  );
}

AlertDialog generateStrikeUserPopUp(UserAccount user) {
  return AlertDialog(
    title: const Text("Give Strike"),

    // Messages for deleting post/chat
    content: Text("Do you want to give this user a strike?"),

    actions: <Widget>[
      FlatButton(
        onPressed: () => locator<NavigationService>().pop(),
        child: const Text("No"),
      ),
      FlatButton(
          onPressed: () async {
            AdminInteraction().clearUserReports(user);
            AdminInteraction().addUserStrike(user);
            AdminInteraction().addProfileStrikeState(user);

            locator<NavigationService>().pop(num: 2);
          },
          child: const Text("Yes")
      ),
    ],
  );
}

List<Row> displayStrikeSnapshots(user) {
  List<Row> strikes = [];
  for (var strikeNum = 0; strikeNum < user.strikes; strikeNum++) {
    var thisStrike = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FlatButton(
            onPressed: () =>
            user.strikesSnapshots[strikeNum - 1]["isPost"]
                ? locator<NavigationService>().navigateWithParameters('/staticpost', user.strikesSnapshots[strikeNum])
                :locator<NavigationService>().navigateWithParameters('/staticprofile', user.strikesSnapshots[strikeNum]),
            child: Text("View Strike " + (strikeNum + 1).toString()),
          ),
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                AdminInteraction().removeStrike(user, strikeNum);
                locator<NavigationService>().pop(num: 2);
              }
          )
        ]
    );
    strikes.add(thisStrike);
  }
  return strikes;
}

Future<AlertDialog> generateStrikesPopUp(UserAccount currUser) async {

  UserAccount user = await UserInteraction().loadSingleUser(currUser.id);

  return AlertDialog(
    title: Column (
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Admin Console", textAlign: TextAlign.center),
          Text("3 strikes = User account disabled.", textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
        ]
    ),

    // Messages for deleting post/chat
    content: Container(
        child: Column (
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: displayStrikeSnapshots(user)
        )
    ),

    actions: <Widget>[

      FlatButton(
        onPressed: () {
          locator<NavigationService>().pop(num: 2);
        },
        child: const Text("Cancel"),
      ),

      FlatButton(
        onPressed: () async {
          AdminInteraction().clearUserReports(user);
          locator<NavigationService>().pop(num: 2);
        },
        child: const Text("Clear Reports"),
      ),

      FlatButton(
          onPressed: () async {

            AdminInteraction().clearUserReports(user);
            AdminInteraction().addUserStrike(user);
            AdminInteraction().addProfileStrikeState(user);

            // Remove dialog
            locator<NavigationService>().pop(num: 2);
          },
          child: const Text("Give strike")
      ),
    ],
  );
}

Future<AlertDialog> generateUserAdminPopUp(UserAccount currUser) async {

  UserAccount user = await UserInteraction().loadSingleUser(currUser.id);

  return AlertDialog(
    title: Column (
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Admin Console", textAlign: TextAlign.center),
          Text("3 strikes = User account disabled.", textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
        ]
    ),

    // Messages for deleting post/chat
    content: Column (
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          user.strikes == 1
              ? Text("User has " + user.strikes.toString() + " strike.")
              : Text("User has " + user.strikes.toString() + " strikes."),
          user.reports == 1
              ? Text("User has been reported " + user.reports.toString() + " time.")
              : Text("User has been reported " + user.reports.toString() + " times."),
        ]
    ),

    actions: <Widget>[
      FlatButton(
        onPressed: () => locator<NavigationService>().pop(),
        child: const Text("Cancel"),
      ),

      FlatButton(
        onPressed: () async {
          AdminInteraction().clearUserReports(user);
          locator<NavigationService>().pop();
        },
        child: const Text("Clear Reports"),
      ),

      FlatButton(
          onPressed: () async {

            AdminInteraction().clearUserReports(user);
            AdminInteraction().addUserStrike(user);
            AdminInteraction().addProfileStrikeState(user);

            // Remove dialog
            locator<NavigationService>().pop(num: 2);
          },
          child: const Text("Give strike")
      ),
    ],
  );
}

Future<AlertDialog> generatePostAdminPopUp(String postId, {@required int feedNum}) async {

  Post post = await getFeed(feedNum).loadSinglePost(postId);
  UserAccount user = await UserInteraction().loadSingleUser(post.author);

  return AlertDialog(
    title: Column (
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Admin Console", textAlign: TextAlign.center),
          Text("3 strikes = User account disabled.", textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
        ]
    ),

    // Messages for deleting post/chat
    content: Column (
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          user.strikes == 1
              ? Text("User has " + user.strikes.toString() + " strike.")
              : Text("User has " + user.strikes.toString() + " strikes."),
          post.reports == 1
              ? Text("Post has been reported " + post.reports.toString() + " time.")
              : Text("Post has been reported " + post.reports.toString() + " times."),

        ]
    ),

    actions: <Widget>[
      FlatButton(
        onPressed: () => locator<NavigationService>().pop(),
        child: const Text("Cancel"),
      ),

      FlatButton(
        onPressed: () async {
          AdminInteraction().clearPostReports(post, feedNum);
          locator<NavigationService>().pop();
        },
        child: const Text("Clear Reports"),
      ),

      FlatButton(
          onPressed: () async {

            feedNum == 0
                ? lookingFeed.deletePost(postId)
                : offeringFeed.deletePost(postId);

            AdminInteraction().addUserStrike(user);
            AdminInteraction().addPostStrikeState(user, post);

            // Remove dialog
            locator<NavigationService>().pop(num: 2);
          },
          child: const Text("Delete Post")
      ),
    ],
  );
}

/* ****************
 * **** CHIPS *****
 * ****************/

// Produces a list of clickable chips from provided UniTags object
List<Widget> chipListBuilder({
  @required UniTags tags,
  @required dynamic parent,
  bool borders = false}) {

  List<Widget> chips = List();

  // Builds chips
  for (String str in tags) {

    FilterChip filterChip;

    // Chip with border
    borders
        ? filterChip = FilterChip(
        shape: StadiumBorder(side: BorderSide(
            color: tags[str]
                ? Colors.white54
                : Colors.grey[700]
        )),
        elevation: 0,
        backgroundColor: Colors.transparent,
        selected: tags[str],
        showCheckmark: false,
        label: Text(str),
        onSelected: (bool selected) {
          tags[str] = selected;
          parent.setMyState();
        }
    )

    // Chip without border
        : filterChip = FilterChip(
        selected:  tags[str],
        showCheckmark: false,
        label: Text(str),
        onSelected: (bool selected) {
          tags[str] = selected;
          parent.setMyState();
        }
    );

    // Adds padding and stores
    chips.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 2),
        child: filterChip
    ));
  }

  return chips;
}

// Horizontally-scrolling chips
Widget horizontalChips(List<Widget> chips) {

  return Container(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: chips,
        ),
      )
  );
}

/* ****************
 * ** EXPANSION ***
 * ****************/

// Custom expansion widget with default values
class UniExpansion extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final FontWeight fontWeight;
  final double fontSize;
  final bool initiallyExpanded;

  UniExpansion({@required this.title,
    @required this.children, this.fontWeight = FontWeight.w500,
    this.fontSize = 15, this.initiallyExpanded = false, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // Sets accent

  }
}

/* ****************
 * ** SCROLLING ***
 * ****************/

// Removes scroll glow
class NoGlowingScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
scrollWithoutAnimation({@required Widget child}) {
  return ScrollConfiguration(
      behavior: NoGlowingScrollBehavior(),
      child: child
  );
}

/* ****************
 * ** REFRESH ***
 * ****************/

class UniRefreshIndicator extends RefreshIndicator {
  UniRefreshIndicator({child, onRefresh}) :
        super(child: child,
          onRefresh: onRefresh,
      );
}