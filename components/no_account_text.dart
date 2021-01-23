import 'package:flutter/material.dart';
import 'package:unistudentapp/screens/sign_up/sign_up_screen.dart';

import '../lib/constants.dart';
import '../lib/size_config.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Vous n'avez pas de compte? ",
          style: TextStyle(fontSize: getProportionateScreenWidth(12),
            fontFamily: "Open_Sans",),

        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, SignUpScreen.routeName),
          child: Text(
            "Inscription",
            style: TextStyle(
                fontSize: getProportionateScreenWidth(12),
                fontFamily: "Open_Sans",
                color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
