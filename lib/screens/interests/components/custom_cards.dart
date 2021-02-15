import 'package:flutter/material.dart';
import 'package:uniapp/size_config.dart';

class CustomCard extends StatefulWidget {
  final String photoURL, text;
  CustomCard(this.photoURL, this.text);
  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black38,
                // Colors.black,
                Color.fromRGBO(0, 65, 196, 1),
              ],
              tileMode: TileMode.clamp,
              stops: [0, 1]).createShader(
            Rect.fromLTRB(-1, 0, rect.width, rect.height), //(180 degree)
          );
        },
        blendMode: BlendMode.dstOver,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(widget.photoURL),
            ),
          ),
          child: OverlayIconText(widget.text),
        ),
      ),
    );
  }
}

class OverlayIconText extends StatefulWidget {
  OverlayIconText(this.text);
  final String text;
  @override
  _OverlayIconTextState createState() => _OverlayIconTextState();
}

class _OverlayIconTextState extends State<OverlayIconText> {
  bool istapped = false;
  List<String> interests = [];

  void toggle() {
    setState(() {
      istapped = !istapped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        toggle();
        //Update Interest List
        if (istapped) {
          interests.add(widget.text);
          print('${widget.text} added');
        }
        if (interests.length > 0 && istapped == false) {
          interests.removeLast();
          print('${widget.text} removed');
        }
        print(interests);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20, left: 80),
            child: SizedBox(
              width: double.infinity,
              child: Icon(
                Icons.check_circle,
                size: 30,
                color: istapped ? Colors.white : Colors.white70,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                widget.text,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontSize: getProportionateScreenHeight(20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
