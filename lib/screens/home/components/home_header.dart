import 'package:flutter/material.dart';
import '../../../size_config.dart';
import 'package:uniapp/enums.dart';
import 'package:uniapp/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uniapp/screens/home/home_screen.dart';



class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key key,
    @required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/map.svg",
                  color: MenuState.home == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, HomeScreen.routeName),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/notif.svg",
                  color: MenuState.profile == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
              ),
            ],
          )),
    );
  }
}
