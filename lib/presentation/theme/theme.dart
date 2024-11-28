import "package:flutter/material.dart";

// https://material-foundation.github.io/material-theme-builder
// #34275E, #7C6EAA, #CDBDFF, #FF5449, #939093, #939093
// https://api.flutter.dev/flutter/material/ThemeData/useMaterial3.html
// https://www.dafont.com/pt/rokiest.font

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);
  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffcdbdff),
      surfaceTint: Color(0xffcdbdff),
      onPrimary: Color(0xff34275e),
      primaryContainer: Color(0xff2c1e55),
      onPrimaryContainer: Color(0xffbaabeb),
      secondary: Color(0xffcdbdff),
      onSecondary: Color(0xff34275e),
      secondaryContainer: Color(0xff7265a0),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xfff0e8ff),
      onTertiary: Color(0xff34275e),
      tertiaryContainer: Color(0xffc8b8fa),
      onTertiaryContainer: Color(0xff362961),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff141317),
      onSurface: Color(0xffe6e1e7),
      onSurfaceVariant: Color(0xffcac4d0),
      outline: Color(0xff938f9a),
      outlineVariant: Color(0xff48454f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe6e1e7),
      inversePrimary: Color(0xff635690),
      primaryFixed: Color(0xffe7deff),
      onPrimaryFixed: Color(0xff1f1048),
      primaryFixedDim: Color(0xffcdbdff),
      onPrimaryFixedVariant: Color(0xff4b3e76),
      secondaryFixed: Color(0xffe8deff),
      onSecondaryFixed: Color(0xff1f1048),
      secondaryFixedDim: Color(0xffcdbdff),
      onSecondaryFixedVariant: Color(0xff4b3e76),
      tertiaryFixed: Color(0xffe8deff),
      onTertiaryFixed: Color(0xff1f1048),
      tertiaryFixedDim: Color(0xffcdbdff),
      onTertiaryFixedVariant: Color(0xff4b3e76),
      surfaceDim: Color(0xff141317),
      surfaceBright: Color(0xff3a383d),
      surfaceContainerLowest: Color(0xff0f0e11),
      surfaceContainerLow: Color(0xff1c1b1f),
      surfaceContainer: Color(0xff201f23),
      surfaceContainerHigh: Color(0xff2b292d),
      surfaceContainerHighest: Color(0xff363438),
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
