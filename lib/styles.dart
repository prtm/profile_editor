import 'package:flutter/material.dart';

const primaryColor = Color(0xff3f51b5);
const primaryDartColor = Color(0xff002984);
const primaryLightColor = Color(0xff757de8);

const secondaryColor = Color(0xfff3c99f);
const secondaryDartColor = Color(0xffbf9870);
const secondaryLightColor = Color(0xfffffcd0);

//custom theme
ThemeData getAppTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    accentColor: secondaryColor,
    buttonColor: secondaryColor,
    primarySwatch: Colors.indigo,
    toggleableActiveColor: secondaryColor,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: secondaryColor,
    ),
    iconTheme: IconThemeData(color: primaryColor),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
