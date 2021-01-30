import 'package:flutter/widgets.dart';
import 'package:uniapp/screens/complete_profile/complete_profile_screen.dart';
import 'package:uniapp/screens/forgot_password/forgot_password_screen.dart';
import 'package:uniapp/screens/login_success/login_success_screen.dart';
import 'package:uniapp/screens/sign_in/components/body.dart';
import 'package:uniapp/screens/sign_in/sign_in_screen.dart';
import 'package:uniapp/screens/splash/splash_screen.dart';
import 'package:uniapp/screens/home/home_screen.dart';

import 'screens/sign_up/sign_up_screen.dart';


final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
};
