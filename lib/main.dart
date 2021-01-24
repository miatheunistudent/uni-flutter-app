import 'package:flutter/material.dart';
import 'package:unistudentapp/routes.dart';
import 'package:unistudentapp/screens/splash/splash_screen.dart';
import 'package:unistudentapp/theme.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme(),
      // home: SplashScreen(),
      // We use routeName so that we dont need to remember the name
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}
