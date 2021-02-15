import 'package:flutter/material.dart';
import 'package:uniapp/screens/home/home_screen.dart';
import 'package:uniapp/size_config.dart';
import '../../components/background.dart';
import 'package:uniapp/screens/interests/components/custom_gridview.dart';

class InterestScreen extends StatelessWidget {
  static String routeName = '/interests';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, HomeScreen.routeName);
            },
            child: Text(
              "Skip",
              style: TextStyle(
                color: Color(0xFF0041C4),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Background(),
          Container(
            margin: EdgeInsets.only(top: 90, left: 20, right: 20),
            color: Colors.transparent,
            child: Column(children: [selectInterest(), CustomGridView()]),
          ),
        ],
      ),
    );
  }
}

Container selectInterest() {
  return Container(
    alignment: Alignment.topLeft,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Interests",
          style: TextStyle(
            color: Colors.black,
            fontSize: getProportionateScreenWidth(28),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text("Customize your interests"),
      ],
    ),
  );
}
