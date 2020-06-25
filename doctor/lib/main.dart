import 'package:doctor/comman/flashView.dart';
import 'package:flutter/material.dart';
import 'package:doctor/style/colors.dart' as CustomColors;

/// App entry point
void main() async {
  // then render the app on screen
  runApp(MyApp());
}

final routes = {
  '/': (BuildContext context) => new FlashScreen(),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      //    routes: routes,
      routes: routes,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: CustomColors.Colors.primaryDark,
        accentColor: CustomColors.Colors.primaryColor,
        primaryColorDark: CustomColors.Colors.primaryColor,
        primaryIconTheme: Theme.of(context)
            .primaryIconTheme
            .copyWith(color: CustomColors.Colors.white),
      ),
    );
  }
}