import "package:flutter/material.dart";

// https://coolors.co/000505-3b3355-5d5d81-bfcde0-fefcfd
// https://material-foundation.github.io/material-theme-builder/
// https://api.flutter.dev/flutter/material/ThemeData/useMaterial3.html

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffcdbdff),
      surfaceTint: Color(0xffcdbdff),
      onPrimary: Color(0xff34275e),
      primaryContainer: Color(0xff4b3e76),
      onPrimaryContainer: Color(0xffe8deff),
      secondary: Color(0xffc1c1ff),
      onSecondary: Color(0xff2a2a60),
      secondaryContainer: Color(0xff404178),
      onSecondaryContainer: Color(0xffe1dfff),
      tertiary: Color(0xff9ecafc),
      onTertiary: Color(0xff003256),
      tertiaryContainer: Color(0xff144974),
      onTertiaryContainer: Color(0xffd0e4ff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0e1514),
      onSurface: Color(0xffdde4e3),
      onSurfaceVariant: Color(0xffc1c7ce),
      outline: Color(0xff8b9198),
      outlineVariant: Color(0xff41484d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdde4e3),
      inversePrimary: Color(0xff63568f),
      primaryFixed: Color(0xffe8deff),
      onPrimaryFixed: Color(0xff1f1048),
      primaryFixedDim: Color(0xffcdbdff),
      onPrimaryFixedVariant: Color(0xff4b3e76),
      secondaryFixed: Color(0xffe1dfff),
      onSecondaryFixed: Color(0xff14134a),
      secondaryFixedDim: Color(0xffc1c1ff),
      onSecondaryFixedVariant: Color(0xff404178),
      tertiaryFixed: Color(0xffd0e4ff),
      onTertiaryFixed: Color(0xff001d34),
      tertiaryFixedDim: Color(0xff9ecafc),
      onTertiaryFixedVariant: Color(0xff144974),
      surfaceDim: Color(0xff0e1514),
      surfaceBright: Color(0xff343a3a),
      surfaceContainerLowest: Color(0xff090f0f),
      surfaceContainerLow: Color(0xff161d1d),
      surfaceContainer: Color(0xff1a2121),
      surfaceContainerHigh: Color(0xff252b2b),
      surfaceContainerHighest: Color(0xff2f3636),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
