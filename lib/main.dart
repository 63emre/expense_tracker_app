import 'package:flutter/material.dart';
import 'widgets/expenses.dart';
import "package:flutter/services.dart";

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 119, 255, 176),
);

var kDarkColorScheme = ColorScheme.fromSeed(seedColor: Colors.teal);
void main() {
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
  //fn,
  //)
  {
    runApp(
      MaterialApp(
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: kDarkColorScheme,
          brightness: Brightness.dark,
          cardTheme: const CardThemeData().copyWith(
            color: Colors.white70,
            margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white70),
          ),
        ),
        theme: ThemeData() /*.dark()*/ .copyWith(
          colorScheme: kColorScheme,
          appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.onPrimaryContainer,
            foregroundColor: kColorScheme.primaryContainer,
          ),
          cardTheme: const CardThemeData().copyWith(
            color: kColorScheme.secondaryContainer,
            margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white70),
          ),

          textTheme: ThemeData().textTheme.copyWith(
            titleLarge: TextStyle(
              fontWeight: FontWeight.bold,
              color: kColorScheme.onSecondaryContainer,
              fontSize: 22,
            ),
          ),
        ),
        themeMode: ThemeMode.system,
        home: Expenses(),
      ),
    );
    // });
  }
}
