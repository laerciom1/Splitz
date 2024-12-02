import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splitz/navigator.dart';

TextTheme createTextTheme(
    BuildContext context, String bodyFontString, String displayFontString) {
  TextTheme baseTextTheme = Theme.of(context).textTheme;
  TextTheme bodyTextTheme =
      GoogleFonts.getTextTheme(bodyFontString, baseTextTheme);
  TextTheme displayTextTheme =
      GoogleFonts.getTextTheme(displayFontString, baseTextTheme);
  TextTheme textTheme = displayTextTheme.copyWith(
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );
  return textTheme;
}

abstract class ThemeColors {
  static Color get primary =>
      Theme.of(AppNavigator.context).colorScheme.primary;
  static Color get onSurface =>
      Theme.of(AppNavigator.context).colorScheme.onSurface;
  static Color get surface =>
      Theme.of(AppNavigator.context).colorScheme.surface;
  static Color get surfaceBright =>
      Theme.of(AppNavigator.context).colorScheme.surfaceBright;
  static Color get inverseSurface =>
      Theme.of(AppNavigator.context).colorScheme.inverseSurface;
  static Color get surfaceContainerLow =>
      Theme.of(AppNavigator.context).colorScheme.surfaceContainerLow;
  static Color get error =>
      Theme.of(AppNavigator.context).colorScheme.error;
}
