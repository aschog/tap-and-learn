import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tap_and_learn/config/theme/app_colors.dart';

class AppTheme {
  static ThemeData get light {
    const surfaceColor = Color(0xFFCDE8F6);
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: GamePalette.blue,
        surface: surfaceColor, // Your custom light blue bg
      ),
      textTheme: GoogleFonts.fredokaTextTheme().copyWith(
        displayLarge: GoogleFonts.fredoka(
          fontSize: 150,
        ),
      ),
      extensions: const [
        GameThemeColors(
          numberBtnColor1: GamePalette.yellow,
          numberBtnColor2: GamePalette.blue,
          numberBtnColor3: GamePalette.orange,
          deleteBtnColor: GamePalette.red,
          textMainColor: GamePalette.textMain,
        ),
      ],
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: const WidgetStatePropertyAll(surfaceColor),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: GamePalette.textMain,
      ),
    );
  }
}
