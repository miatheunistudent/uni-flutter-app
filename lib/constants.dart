import 'package:flutter/material.dart';
import 'package:unistudentapp/size_config.dart';

const kPrimaryColor = Color(0xFF003481);
const kPrimaryLightColor = Color(0xFF7A869A);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Merci de renseigner une adresse email";
const String kInvalidEmailError = "Merci de renseigner un nom d'utilisateur valide";
const String kPassNullError = "Merci de renseigner un mot de passe";
const String kShortPassError = "Le mot de passe est trop court";
const String kMatchPassError = "Le mot de passe saisi ne correspond pas";
const String kNamelNullError = "Merci de renseigner un nom";
const String kPhoneNumberNullError = "Veuillez entrer un numero de téléphone valide";
const String kAddressNullError = "Veuillez renseigner une adresse mail";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}
