import 'package:flutter/material.dart';
import 'package:smct/core/routes/routes.dart';
import 'package:smct/core/themes/themes.dart';

void main() {
  runApp(const MentalCalc());
}

class MentalCalc extends StatelessWidget {
  const MentalCalc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: main_theme,
      routes: routes,
      initialRoute: '/',
    );
  }
}
