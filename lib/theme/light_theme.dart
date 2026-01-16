import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  useMaterial3: false,
  fontFamily: 'TitilliumWeb',
  primaryColor: const Color(0xFF245D5F),
  hintColor : const Color(0xff9E9E9E),
  ///0xff0007a3  0xff1c4c9e
  bottomSheetTheme:
      const BottomSheetThemeData(backgroundColor: Colors.transparent),
  brightness: Brightness.light,
  highlightColor: const Color(0xFF9DC5C5),
  //highlightColor: Colors.white,
  //hintColor: const Color(0xFF9E9E9E),
  disabledColor: const Color(0xFF343A40),
  canvasColor: const Color(0xFFFCFCFC),
  colorScheme: const ColorScheme.light(

      primary: Color(0xFF245D5F),
      secondary: Color(0xFFE4E4E4),
      tertiary: Color(0xFFF9D4A8),
      tertiaryContainer: Color(0xFFADC9F3),
      onTertiaryContainer: Color(0xFF33AF74),
      primaryContainer: Color(0xFFF5F5F5),
      secondaryContainer: Color(0xFFF2F2F2),
      error: Color(0xFFFF5A5A),
      surface: Color(0xffbadff8),
     // surfaceTint: Color(0xFF0007a3),
     // onPrimary: Color(0xFF0007a3),
      onSecondary: Color(0xFFFC9926)),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);
