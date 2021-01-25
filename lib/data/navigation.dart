/* ************************************************************************
 * FILE : navigation.dart
 * DESC : Assists with navigation between pages.
 * ************************************************************************
 */

import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:unistudentapp/data/globalWidgets.dart';
import 'package:unistudentapp/data/globals.dart';


// Remove search focus when moving pages
void removeSearchFocus() {
  lookingSearchController.unfocus();
  offeringSearchController.unfocus();
}

// Set up location package
GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
}

// Service used to move to new pages
class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  // Adds named page to top of stack
  Future<dynamic> navigateTo(String routeName) {
    removeSearchFocus();
    return navigatorKey.currentState.pushNamed(routeName);
  }

  // Adds named page + parameters to top of stack
  Future<dynamic> navigateWithParameters(String routeName, var passedArgument) {
    removeSearchFocus();
    return navigatorKey.currentState
        .pushNamed(routeName, arguments: passedArgument);
  }

  // Adds named page + key to top of stack
  Future<dynamic> navigateWithKey(String routeName, Key key) {
    removeSearchFocus();
    return navigatorKey.currentState.pushNamed(routeName, arguments: key);
  }

  // Clears stack and adds named page to top
  Future<dynamic> popAllPushNamed(String routeName) {
    removeSearchFocus();
    return navigatorKey.currentState
      .pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
  }

  // Pops all pages from stack until home
  Future<dynamic> goHome() {
    removeSearchFocus();
    navigatorKey.currentState.popUntil((route) => route.isFirst);
    return null;
  }

  // Pops single page
  Future<dynamic> pop({int num = 1, dynamic result}) {

    // First few pops
    for (int i = 0; i < num - 1; i++)
      navigatorKey.currentState.pop();

    // Sends result
    result == null
      ? navigatorKey.currentState.pop()
      : navigatorKey.currentState.pop(result);
    return null;
  }

  // Opens post popup
  Future<dynamic> launchPost(post) async {
    removeSearchFocus();
    showMaterialModalBottomSheet(
      context: navigatorKey.currentContext,
      builder: (context, scrollController) => scrollWithoutAnimation(
        child: SingleChildScrollView(
          controller: scrollController,
          child: PostPopupPage(post)
        )
      ),
      shape: BOTTOM_SHEET
    );
    return null;
  }

  // Opens post popup
  Future<dynamic> launchStaticPost(postContents) async {
    removeSearchFocus();
    showMaterialModalBottomSheet(
      context: navigatorKey.currentContext,
      builder: (context, scrollController) => scrollWithoutAnimation(
        child: SingleChildScrollView(
          controller: scrollController,
          child: StaticPostPopupPage(postContents)
        )
      ),
      shape: BOTTOM_SHEET
    );
    return null;
  }

    // Opens post popup
  Future<dynamic> launchProfilePopUp(user) async {
    removeSearchFocus();
    showMaterialModalBottomSheet(
      context: navigatorKey.currentContext,
      builder: (context, scrollController) => scrollWithoutAnimation(
        child: SingleChildScrollView(
          controller: scrollController,
          child: UserPopUpPage(user)
        )
      ),
      shape: BOTTOM_SHEET
    );
    return null;
  }

  // Opens filter popup
  Future<dynamic> launchFeedFilters(postFeed, searchBarState, Key key) async {
    removeSearchFocus();
    showMaterialModalBottomSheet(
      context: navigatorKey.currentContext,
      builder: (context, scrollController) => scrollWithoutAnimation(
        child: SingleChildScrollView(
          controller: scrollController,
          child: PostFeedFilters(postFeed, searchBarState, key: key)
        )
      ),
      shape: BOTTOM_SHEET
    );
    return null;
  }
}
