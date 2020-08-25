import 'package:flutter/material.dart';
import 'package:stocker/root.dart';
import 'package:stocker/utilities/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login Page test",
      color: Colors.white,
      theme: ThemeData(fontFamily: 'Roboto', accentColor: AppleColors.gray6),
      home: RootPage(),
    );
  }
}
