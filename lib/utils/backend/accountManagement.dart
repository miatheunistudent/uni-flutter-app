/* ************************************************************************
 * FILE : accountManagement.dart
 * DESC : Handles interaction with accounts in the database.
 * ************************************************************************
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unistudentapp/data/globals.dart';
import 'package:unistudentapp/utils/backend/userInteraction.dart';

// Used to interact with accounts
class AccountManagement {

  // Login with a username and password
  Future<dynamic> login(String email, String password) async {
    UserCredential result;
    User user;

    // Attempt login with Uni email
    try{
      result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: email,
          password: password
      );
      
      // Make sure latest globals are loaded
      await dynamicGlobals.loadGlobals(online: true);
    }
    catch(error) {
      await FirebaseAuth.instance.signOut();

      if (error.toString().contains('user-not-found'))
        return 'Account not found.';
      if (error.toString().contains('wrong-password'))
        return 'Wrong password.';
     return 'There was an error. Please try again later.';
    }

    // Result
    user = result.user;

    if (user == null)
      return 'There was an error. Please try again later.';

    // Logout if not verified
    if (!verified()){
      logout();
      return 'Please check your email to verify.';
    }

    // Success, setup Algolia
    algoliaInstance = await apiCredentials.getAlgoliaCredfromFb();
    return true;
  }

  // Creates a new account with email and password
  Future<dynamic> createNewAccount(String email, String password) async {
    UserCredential result;
    User user;

    // Attempt to create new account with Hamilton email
    try {
      result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
    }
    catch(error) {
      if (error.toString().contains('email-already-in-use'))
        return 'An account with this email already exists.';
        
      return 'There was an error. Please try again later.';
    }

    // Result
    user = result.user;

    if (user == null)
      return 'There was an error. Please try again later.';

    // Verify user
    await user.sendEmailVerification();
    return true;
  }

  // Sends user recovery code to reset password
  Future<dynamic> forgotPassword(String email) async {
    try{
      // Send user password code
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email
      );
      return true;
    }
    catch(error) {
      if (error.toString().contains('user-not-found'))
        return 'Account not found.';
      else
        return 'There was an error. Please try again later.';
    }
  }

   Future<dynamic> updatePassword(String oldPassword, String newPassword) async {

    // Check whether provided password works
    bool correctPassword = await checkPassword(oldPassword);
    if (correctPassword == null)
      return 'There was an error. Please try again later.';
    if (!correctPassword)
      return 'Incorrect password. Please try again.';

    // Attempts to set new password
    try {
      await FirebaseAuth.instance.currentUser.updatePassword(newPassword);
      return true;
    }

    // On error
    catch(error) {
      return 'There was an error. Please try again later.';
    }
  }

  // Returns whether a user is currently logged in
  bool loggedIn() {
    return verified();
  }

  // Returns whether a user account is verified
  bool verified() {
    User user = FirebaseAuth.instance.currentUser;
    if (user != null) return user.emailVerified;
    else return false;
  }

  // Returns whether a user has setup an account yet
  Future<bool> isUserNew() async {
    User user = FirebaseAuth.instance.currentUser;
    if (user == null) return true;
    return await UserInteraction().isUserNew(user.uid);
  }

  // Logout for a user
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    await clearLocalAppData();
  }

  // Checks user password
  Future<dynamic> checkPassword(String password) async {

    // Gets user object
    User user = FirebaseAuth.instance.currentUser;

    // Generates credentials
    AuthCredential credential = EmailAuthProvider.credential(
      email: user.email,
      password: password,
    );

    // Attempts to authenticate
    try{
      await FirebaseAuth.instance.currentUser.reauthenticateWithCredential(
        credential
      );
      return true;
    }
    catch(error) {

      // Bad password
      if (error.toString().contains('wrong-password'))
        return false;

      // Other error
      else
        return null;
    }
  }

  // Deletes a user given username and password
  Future<dynamic> deleteUser(String password) async {

    // Check whether provided password works
    bool correctPassword = await checkPassword(password);
    if (correctPassword == null)
      return 'There was an error. Please try again later.';
    if (!correctPassword)
      return 'Incorrect password. Please try again.';

    // Deletes user
    try {
      await FirebaseAuth.instance.currentUser.delete();
    }
    catch(error) {
      return 'There was an error. Please try again later.';
    }
    
    await clearLocalAppData();

    return true;
  }

  // Returns current user's id
  String currentUserId() {
    if (FirebaseAuth.instance.currentUser != null)
      return FirebaseAuth.instance.currentUser.uid;
    else return null;
  }
  
  Future<void> clearLocalAppData() async {

    // Clear cache
    await FirebaseFirestore.instance.terminate();
    await FirebaseFirestore.instance.clearPersistence();

  }
}