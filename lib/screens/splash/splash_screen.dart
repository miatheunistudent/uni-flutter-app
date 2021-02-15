import 'package:flutter/material.dart';
import 'package:uniapp/screens/home/home_screen.dart';
import 'package:uniapp/screens/splash/components/body.dart';
import 'package:uniapp/size_config.dart';
import 'package:provider/provider.dart';
import 'package:uniapp/models/user.dart';
import 'package:uniapp/screens/sign_in/sign_in_screen.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/splash";

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    final user = Provider.of<AppUser>(context);
    print(user);
    if (user == null) {
      return Scaffold(
        body: Body(),
      );
    } else {
      return HomeScreen();
    }
  }
}
