import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 1,
          child: Image.asset(
            "assets/images/image1.png",
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
