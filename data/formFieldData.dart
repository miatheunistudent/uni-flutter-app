/* ************************************************************************
 * FILE : formFieldData.dart
 * DESC : Produces fields used in creating/updating user accounts.
 * ************************************************************************
 */

import 'package:flutter/material.dart';
import 'package:unistudentapp/data/dynamicGlobals.dart';
import 'package:unistudentapp/data/globalWidgets.dart';
import 'package:unistudentapp/post/contentModeration.dart';
import 'package:unistudentapp/utils/backend/feedInteraction.dart';
import 'package:unistudentapp/utils/backend/userInteraction.dart';

// Allows for passing strings by reference, not value
class StringData {
  String string;
  StringData(this.string);
}

// Stores and validates username string
class UsernameField {

  UserAccount account;
  UsernameField(this.account);

  bool checking;
  bool usernameUsed;

  String uniqueUsername(String username) {
    if (checking) return 'Checking username . . .';
    return usernameUsed
        ? 'Username already in use'
        : null;
  }

  Future<void> uniqueUsernameAsync(String username) async {
    checking = true;
    usernameUsed = null;
    usernameUsed = await UserInteraction().usernameUsed(username);
    checking = false;
  }

  // Ensures the username is valid username.
  String validateUsername(value){
    if (value.trim().isEmpty){
      return 'Username Required';
    }
    else if (!RegExp('^[0-9a-zA-z_]*\$').hasMatch(value)){
      return 'Please use only A-Z, a-z, 0-9, _ and .';
    }
    else if (containsBadWords(value)){
      return 'Username cannot contain bad words';
    }
    else{
      return uniqueUsername(value);
    }
  }

  createField() {
    return TextFormField(
      initialValue: account.userName == ''
          ? null
          : account.userName,
      autofocus: false,
      onChanged: (value) => uniqueUsernameAsync(value),
      onSaved: (value) => account.userName = value.trim(),
      validator: (value) => validateUsername(value),
      decoration: InputDecoration(hintText: 'Username'),
    );
  }
}

// Ensures the bio is valid bio.
String validateBio(value){
  if (value.trim().isEmpty){
    return 'Bio cannot be empty.';
  }
  else if (containsBadWords(value)){
    return 'Bio cannot contain bad words';
  }
  else {
    return null;
  }
}

TextFormField bioField(UserAccount account) {
  return TextFormField(
    initialValue: account.bio == ''
        ? null
        : account.bio,
    onSaved: (value) => account.bio = value,
    textCapitalization: TextCapitalization.sentences,
    keyboardType: TextInputType.multiline,
    maxLines: null,
    maxLengthEnforced: true,
    maxLength: 280,
    minLines: 8,
    autofocus: false,
    validator: (value) =>
        validateBio(value),
    decoration: InputDecoration(
      hintText: 'Add Bio',
    ),
  );
}

TextFormField emailField(StringData email) {
  return TextFormField(
    autofocus: false,
    validator: (value) {
      value = value.trim();
      return value.isEmpty
          ? 'Email required'
          : RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@etu.")
          .hasMatch(value)
          ? null
          : 'Email invalid';
    },
    onSaved: (String value) { email.string = value.trim();  },
    decoration: InputDecoration(hintText: 'Email'),
  );
}

TextFormField passwordField(StringData password) {
  return TextFormField(
    autofocus: false,
    validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
    obscureText: true,
    onSaved: (String value) {
      password.string = value;
    },
    decoration: InputDecoration(
      hintText: 'Password',
    ),
  );
}

TextFormField newPasswordField(StringData password) {
  return TextFormField(
    autofocus: false,
    validator: (value) => value.isEmpty
        ? 'Password can\'t be empty'
        : value.length < 8
        ? 'Password must be at least eight characters long'
        : value.contains(RegExp('/s'))
        ? 'Cannot include spaces'
        : !RegExp('.*[A-Z].*').hasMatch(value)
        ? 'Requires capital letters'
        : !RegExp('.*[a-z].*').hasMatch(value)
        ? 'Requires lowercase letters'
        : !RegExp('.*[0-9].*').hasMatch(value)
        ? 'Requires number'
        : !RegExp('.*[@#\$%\^&\+=_!\?\.-].*').hasMatch(value)
        ? 'Requires symbol'
        : null,
    obscureText: true,
    onSaved: (String value) {
      password.string = value;
    },
    decoration: InputDecoration(
      hintText: 'Password',
    ),
  );
}

TextFormField passwordConfirmField(StringData password, StringData passwordConfirm) {
  return TextFormField(
      onSaved: (String value) => passwordConfirm.string = value,
      autofocus: false,
      obscureText: true,
      validator: (value) =>
      value != password.string ? 'Passwords do not match' : null,
      decoration: InputDecoration(
        hintText: 'Confirm Password',
      )
  );
}

// Creates tags (i.e. on campus, off campus, etc.)
SingleChildScrollView buildChips(PostTags tags, dynamic parent, {bool borders = false}) {

  List<Widget> chips = chipListBuilder(
      tags: tags,
      parent: parent,
      borders: borders
  );

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(children: chips),
  );
}

// Creates skills (i.e. biology, cooking, etc.)
Widget buildSkillChips(UserAccount account, dynamic parent) {

  List<Widget> chips = chipListBuilder(
      tags: account.skills,
      parent: parent
  );

  return Wrap(
    alignment: WrapAlignment.center,
    spacing: 1.0,
    runSpacing: 1.0,
    children: chips,
  );
}

// Creates row of selectable icons
SizedBox buildIconChips(UserAccount account, dynamic parent) {
  List<Widget> chips = new List();

  for (String iconStr in categoryOptionsList) {
    ChoiceChip choiceChip = ChoiceChip(
        padding: const EdgeInsets.symmetric(vertical: 25,horizontal: 20),
        shape: RoundedRectangleBorder(),
        backgroundColor: Color(0xFF3c528d),
        selected: account.avatarIcon == iconStr,
        label: Align(
            alignment: Alignment.topCenter,
            child: Icon(skillIcons[iconStr], color: Colors.white, size: 30)
        ),
        onSelected: (bool selected) {
          account.avatarIcon = iconStr;
          parent.setMyState();
        }
    );

    chips.add(
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 1), child: choiceChip)
    );
  }

  return SizedBox(
      height: 80.0,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: chips,
      )
  );
}

// Creates row of selectable colors
SizedBox buildColorChips(UserAccount account, dynamic parent) {
  List<Widget> chips = new List();

  for (String colorStr in avatarColorNames){
    ChoiceChip choiceChip = ChoiceChip(
        padding: const EdgeInsets.symmetric(vertical: 25,horizontal: 20),
        selectedColor: avatarColors[account.avatarColor].withOpacity(0.5),
        shape: RoundedRectangleBorder(),
        backgroundColor: avatarColors[colorStr],
        selected: account.avatarColor == colorStr,
        label: Text(""),
        onSelected: (bool selected) {
          account.avatarColor = colorStr;
          parent.setMyState();
        }
    );

    chips.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 1), child: choiceChip)
    );
  }

  return SizedBox(
      height: 50.0,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: chips,
      )
  );
}