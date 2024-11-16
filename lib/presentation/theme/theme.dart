import "package:flutter/material.dart";

// https://coolors.co/000505-3b3355-5d5d81-bfcde0-fefcfd
// https://material-foundation.github.io/material-theme-builder/
// https://api.flutter.dev/flutter/material/ThemeData/useMaterial3.html

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff63568f),
      surfaceTint: Color(0xff63568f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffe8deff),
      onPrimaryContainer: Color(0xff1f1048),
      secondary: Color(0xff585992),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffe1dfff),
      onSecondaryContainer: Color(0xff14134a),
      tertiary: Color(0xff33618d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffd0e4ff),
      onTertiaryContainer: Color(0xff001d34),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfff4fbfa),
      onSurface: Color(0xff161d1d),
      onSurfaceVariant: Color(0xff41484d),
      outline: Color(0xff71787e),
      outlineVariant: Color(0xffc1c7ce),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3231),
      inversePrimary: Color(0xffcdbdff),
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
      surfaceDim: Color(0xffd5dbda),
      surfaceBright: Color(0xfff4fbfa),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f4),
      surfaceContainer: Color(0xffe9efee),
      surfaceContainerHigh: Color(0xffe3e9e9),
      surfaceContainerHighest: Color(0xffdde4e3),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff473a72),
      surfaceTint: Color(0xff63568f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff7a6ca7),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff3c3d74),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff6e6faa),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff0e4570),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff4b78a5),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff4fbfa),
      onSurface: Color(0xff161d1d),
      onSurfaceVariant: Color(0xff3d4449),
      outline: Color(0xff596066),
      outlineVariant: Color(0xff757b82),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3231),
      inversePrimary: Color(0xffcdbdff),
      primaryFixed: Color(0xff7a6ca7),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff61538d),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff6e6faa),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff56568f),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff4b78a5),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff305f8b),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd5dbda),
      surfaceBright: Color(0xfff4fbfa),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f4),
      surfaceContainer: Color(0xffe9efee),
      surfaceContainerHigh: Color(0xffe3e9e9),
      surfaceContainerHighest: Color(0xffdde4e3),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff26184f),
      surfaceTint: Color(0xff63568f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff473a72),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff1b1b51),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff3c3d74),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff00243f),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff0e4570),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff4fbfa),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff1e252a),
      outline: Color(0xff3d4449),
      outlineVariant: Color(0xff3d4449),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3231),
      inversePrimary: Color(0xfff1e8ff),
      primaryFixed: Color(0xff473a72),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff30235a),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff3c3d74),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff26265c),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff0e4570),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff002f50),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd5dbda),
      surfaceBright: Color(0xfff4fbfa),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f4),
      surfaceContainer: Color(0xffe9efee),
      surfaceContainerHigh: Color(0xffe3e9e9),
      surfaceContainerHighest: Color(0xffdde4e3),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

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

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffd1c2ff),
      surfaceTint: Color(0xffcdbdff),
      onPrimary: Color(0xff1a0942),
      primaryContainer: Color(0xff9688c5),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffc6c6ff),
      onSecondary: Color(0xff0e0d45),
      secondaryContainer: Color(0xff8b8bc8),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffa3cfff),
      onTertiary: Color(0xff00172c),
      tertiaryContainer: Color(0xff6894c3),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0e1514),
      onSurface: Color(0xfff6fcfb),
      onSurfaceVariant: Color(0xffc5cbd2),
      outline: Color(0xff9da4aa),
      outlineVariant: Color(0xff7d848a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdde4e3),
      inversePrimary: Color(0xff4c3f77),
      primaryFixed: Color(0xffe8deff),
      onPrimaryFixed: Color(0xff14033d),
      primaryFixedDim: Color(0xffcdbdff),
      onPrimaryFixedVariant: Color(0xff3a2d64),
      secondaryFixed: Color(0xffe1dfff),
      onSecondaryFixed: Color(0xff080641),
      secondaryFixedDim: Color(0xffc1c1ff),
      onSecondaryFixedVariant: Color(0xff303066),
      tertiaryFixed: Color(0xffd0e4ff),
      onTertiaryFixed: Color(0xff001224),
      tertiaryFixedDim: Color(0xff9ecafc),
      onTertiaryFixedVariant: Color(0xff00385f),
      surfaceDim: Color(0xff0e1514),
      surfaceBright: Color(0xff343a3a),
      surfaceContainerLowest: Color(0xff090f0f),
      surfaceContainerLow: Color(0xff161d1d),
      surfaceContainer: Color(0xff1a2121),
      surfaceContainerHigh: Color(0xff252b2b),
      surfaceContainerHighest: Color(0xff2f3636),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffef9ff),
      surfaceTint: Color(0xffcdbdff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffd1c2ff),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffdf9ff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffc6c6ff),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffafaff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffa3cfff),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0e1514),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfff8fbff),
      outline: Color(0xffc5cbd2),
      outlineVariant: Color(0xffc5cbd2),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdde4e3),
      inversePrimary: Color(0xff2e2057),
      primaryFixed: Color(0xffece2ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffd1c2ff),
      onPrimaryFixedVariant: Color(0xff1a0942),
      secondaryFixed: Color(0xffe6e4ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffc6c6ff),
      onSecondaryFixedVariant: Color(0xff0e0d45),
      tertiaryFixed: Color(0xffd7e8ff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffa3cfff),
      onTertiaryFixedVariant: Color(0xff00172c),
      surfaceDim: Color(0xff0e1514),
      surfaceBright: Color(0xff343a3a),
      surfaceContainerLowest: Color(0xff090f0f),
      surfaceContainerLow: Color(0xff161d1d),
      surfaceContainer: Color(0xff1a2121),
      surfaceContainerHigh: Color(0xff252b2b),
      surfaceContainerHighest: Color(0xff2f3636),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
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


  List<ExtendedColor> get extendedColors => [
  ];
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
