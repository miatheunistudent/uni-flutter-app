import 'package:flutter/material.dart';
import 'package:uniapp/components/custom_bottom_nav_bar.dart';
import 'package:uniapp/enums.dart';
import 'package:uniapp/services/auth.dart';
import 'package:uniapp/screens/sign_in/sign_in_screen.dart';
import 'package:uniapp/components/background.dart';

class UserProfile extends StatefulWidget {
  static String routeName = "/profile";

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Center(
            child: FlatButton(
              onPressed: () async {
                await _authService.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, SignInScreen.routeName, (_) => false);
              },
              child: Text('Logout'),
            ),
          )
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
