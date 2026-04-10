import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/l10n/app_localizations.dart';
import 'package:todo_app/pages/journal_home_page.dart';
import 'package:todo_app/services/journal_store.dart';

class DevJournalApp extends StatefulWidget {
  const DevJournalApp({super.key, required this.store});

  final JournalStore store;

  @override
  State<DevJournalApp> createState() => _DevJournalAppState();
}

class _DevJournalAppState extends State<DevJournalApp> {
  Locale? _locale;

  void _toggleLocale() {
    setState(() {
      _locale = _locale?.languageCode == 'zh'
          ? const Locale('en')
          : const Locale('zh');
    });
  }

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFFF6EFE4);
    const surface = Color(0xFFFFFBF5);
    const primary = Color(0xFF17313E);
    const secondary = Color(0xFF2C7A72);
    const tertiary = Color(0xFFBE7C4D);

    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      surface: surface,
    );
    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme();
    final displayFont = GoogleFonts.frauncesTextTheme(baseTextTheme);

    return MaterialApp(
      locale: _locale,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: scheme,
        scaffoldBackgroundColor: background,
        useMaterial3: true,
        textTheme: baseTextTheme.copyWith(
          displayLarge: displayFont.displayLarge,
          displayMedium: displayFont.displayMedium,
          displaySmall: displayFont.displaySmall,
          headlineLarge: displayFont.headlineLarge,
          headlineMedium: displayFont.headlineMedium,
          headlineSmall: displayFont.headlineSmall,
          titleLarge: displayFont.titleLarge,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: primary,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: primary,
          contentTextStyle: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,
          hintStyle: const TextStyle(color: Color(0xFF8E877D)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: const BorderSide(color: Color(0xFFE4D8C8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: const BorderSide(color: Color(0xFFE4D8C8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: const BorderSide(color: secondary, width: 1.6),
          ),
        ),
        cardTheme: CardThemeData(
          color: surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: Color(0xFFE6DCCD)),
          ),
        ),
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: ButtonStyle(
            side: WidgetStateProperty.all(
              const BorderSide(color: Color(0xFFDCCFBD), width: 1),
            ),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return primary;
              }
              return surface;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white;
              }
              return primary;
            }),
            textStyle: WidgetStateProperty.all(
              GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primary,
            side: const BorderSide(color: Color(0xFFD7CBBC)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: surface,
          selectedColor: const Color(0xFFDDE9E4),
          secondarySelectedColor: const Color(0xFFDDE9E4),
          side: const BorderSide(color: Color(0xFFE3D8C8)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          labelStyle: GoogleFonts.plusJakartaSans(
            color: primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: tertiary,
          foregroundColor: Colors.white,
          elevation: 8,
          highlightElevation: 10,
        ),
      ),
      home: JournalHomePage(store: widget.store, onToggleLocale: _toggleLocale),
    );
  }
}
