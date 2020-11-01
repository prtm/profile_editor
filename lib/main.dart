import 'package:flutter/material.dart';
import 'package:profile_editor/styles.dart';
import 'package:profile_editor/ui/profile/profile_screen.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: getAppTheme(),
      home: ProfileScreen(),
    );
  }
}
