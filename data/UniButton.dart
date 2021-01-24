/* ************************************************************************
 * FILE : UniButton.dart
 * DESC : Button used throughout application.
 * ************************************************************************
 */

import 'package:flutter/material.dart';
import 'package:unistudentapp/data/globals.dart';

class UniButton extends StatefulWidget {

  final String str;
  final Function action;
  final dynamic parameter;
  final bool bold;
  final bool invertColors;
  final GlobalKey<FormState> validator;

  UniButton(this.str, this.action,
      {this.parameter,
        this.bold = false,
        this.invertColors = false,
        this.validator});

  UniButtonState createState() => UniButtonState();
}

class UniButtonState extends State<UniButton> {

  bool loading = false;

  Widget loadingWidget() {
    return Positioned(
        top: 0, bottom: 0, left: 0, right: 0,
        child: Visibility(
            visible: loading,
            child: Center(child: Theme(
                data: Theme.of(context).copyWith(accentColor: PRIMARY_COLOR),
                child: LinearProgressIndicator())
            ))
    );
  }

  Widget textWidget() {
    return Text(
        this.widget.str,
        style: this.widget.bold
            ? TextStyle(
            color: loading ? Colors.transparent : PRIMARY_COLOR,
            fontWeight: FontWeight.w700,
            fontSize: 16.0
        )
            : TextStyle(color: loading ? Colors.transparent : PRIMARY_COLOR)
    );
  }

  Widget build(BuildContext context) {
    return Center(
        child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.only(left: 28, right: 28, top: 14, bottom: 14),
            color: this.widget.invertColors ? PRIMARY_COLOR : Colors.white,
            textColor: this.widget.invertColors ? Colors.white : PRIMARY_COLOR,
            child: Stack(
              children: [textWidget(), loadingWidget()],
            ),
            onPressed: () async {

              setState(() { loading = true;});

              // Save state
              if (this.widget.validator != null) this.widget.validator.currentState.save();

              // Calls with parameters after validating
              if (this.widget.validator == null || this.widget.validator.currentState.validate()) {
                if (this.widget.parameter == null)
                  await this.widget.action.call();
                else
                  await this.widget.action.call(this.widget.parameter);
              }

              setState(() { loading = false;});

            }
        )
    );
  }
}