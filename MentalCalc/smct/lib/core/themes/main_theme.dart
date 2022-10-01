part of 'themes.dart';

final main_theme = ThemeData.from(
  useMaterial3: true,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    // Primary
    primary: Color(0xffFFB77E),
    onPrimary: Color(0xff4F2500),
    primaryContainer: Color(0xff703800),
    onPrimaryContainer: Color(0xffFFDCC2),
    // Secondary
    secondary: Color(0xffE3BFA6),
    onSecondary: Color(0xff422B1A),
    secondaryContainer: Color(0xff5A412F),
    onSecondaryContainer: Color(0xffFFDCC2),
    // Tertiary
    tertiary: Color(0xffC6CA95),
    onTertiary: Color(0xff2F330B),
    tertiaryContainer: Color(0xff464A21),
    onTertiaryContainer: Color(0xffE3E7AF),
    // Error
    error: Color(0xffFFB4A9),
    onError: Color(0xff680003),
    errorContainer: Color(0xff930006),
    onErrorContainer: Color(0xffFFDAD4),
    // Background
    background: Color(0xffECE0DA),
    onBackground: Color(0xff201A17),
    surface: Color(0xffECE0DA),
    onSurface: Color(0xff201A17),
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.oswald(
      // height: 64,
      fontSize: 57,
      fontWeight: FontWeight.w400,
    ),
    displayMedium: GoogleFonts.oswald(
      // height: 52,
      fontSize: 45,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: GoogleFonts.oswald(
      // height: 44,
      fontSize: 36,
      fontWeight: FontWeight.w400,
    ),
    headlineLarge: GoogleFonts.oswald(
      // height: 40,
      fontSize: 32,
      fontWeight: FontWeight.w400,
    ),
    headlineMedium: GoogleFonts.oswald(
      // height: 36,
      fontSize: 28,
      fontWeight: FontWeight.w400,
    ),
    headlineSmall: GoogleFonts.oswald(
      // height: 32,
      fontSize: 24,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: GoogleFonts.openSans(
      // height: 28,
      fontSize: 22,
      fontWeight: FontWeight.w400,
    ),
    titleMedium: GoogleFonts.openSans(
      // height: 24,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.openSans(
      // height: 20,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: GoogleFonts.openSans(
      // height: 20,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: GoogleFonts.openSans(
      // height: 16,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: GoogleFonts.openSans(
      // height: 16,
      fontSize: 11,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: GoogleFonts.openSans(
      // height: 24,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: GoogleFonts.openSans(
      // height: 20,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: GoogleFonts.openSans(
      // height: 16,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
  ),
);
