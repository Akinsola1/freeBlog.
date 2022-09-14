import 'package:flutter/material.dart';

class AppColors {
  static const primaryColor = Color(0xffE4EFFF);
  static const secondaryColor = Color(0xff36474f);
  static const scaffoldBackground = Color(0xffE4EFFF);



  static final primaryColorLight = Color(0xffD1E1FF);

  static final splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xff36474f),
      Color(0xff36474f).withOpacity(0.8),
    ],
  );
}
