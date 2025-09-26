import 'package:flutter/material.dart';

class AppColors {
  // === Primary Brand Colors ===
  static const cardColor = Color.fromRGBO(30, 30, 30, 1);
  static const Color primary = Color(0xFF1DB954); // Spotify green
  static const Color primaryDark = Color(0xFF1AA34A);
  static const Color accent = Color(0xFF1ED760); // Accent green

  // === Backgrounds ===
  static const Color backgroundDark = Color(0xFF121212); // Spotify dark mode
  static const Color backgroundLight = Color(0xFFF5F5F5); // Light mode

  // === Text Colors ===
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.grey;
  static const Color textDark = Color(0xFF333333);

  // === Buttons ===
  static const Color buttonPrimary = Color(0xFF1DB954);
  static const Color buttonSecondary = Color(0xFF535353);

  // === Error, Success, Warning ===
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFBC02D);

  // === Borders, Dividers ===
  static const Color divider = Color(0xFFBDBDBD);
  static const Color border = Color(0xFF424242);

  // === Other UI Elements ===
  static const Color card = Color(0xFF1E1E1E);
  static const Color overlay = Colors.black54;
  static const Color shadow = Colors.black12;

  static const grad1 = LinearGradient(
    colors: [
      Color.fromARGB(255, 222, 76, 248),
      Color.fromARGB(255, 163, 18, 163),
      Color.fromARGB(255, 201, 17, 161),
    ],
  );

  static const grad2 = LinearGradient(
    colors: [Colors.purpleAccent, Colors.purple, Colors.purpleAccent],
  );
  static const grad3 = LinearGradient(
    colors: [Colors.purpleAccent, Colors.purple, Colors.purpleAccent],
  );

  static const line1 = LinearGradient(
    colors: [
      Color.fromARGB(255, 205, 47, 233),
      Color.fromARGB(255, 207, 64, 251),
      Color.fromARGB(255, 207, 47, 233),
      Colors.purple,
      Color.fromARGB(255, 68, 18, 77),
    ],
  );

  static const line0 = LinearGradient(
    colors: [
      Color.fromARGB(255, 238, 81, 230),
      Color.fromRGBO(204, 58, 197, 11),
      Color.fromARGB(255, 142, 26, 172),
    ],
  );

  static const line2 = LinearGradient(
    colors: [
      Color.fromARGB(255, 34, 1, 33),
      Color.fromARGB(255, 80, 8, 102),
      Color.fromARGB(255, 37, 5, 28),
    ],
  );

  static const line4 = LinearGradient(
    colors: [
      Color.fromARGB(255, 121, 34, 116),
      Color.fromRGBO(204, 58, 197, 11),
      Color.fromARGB(255, 142, 26, 172),
    ],
  );

  static const dottedBorder = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
    ],
  );
}
