import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BloomTheme {
 // Primary Logo Palette - Organic, Warm, Dusty Blossom & Sage
 static const Color primaryRose = Color(0xFFD88C9A); // Dusty Blossom Pink
 static const Color secondaryPeach = Color(0xFFF0C2C8); // Soft Petal Pink
 static const Color sageGreen = Color(0xFF82A37D); // Sage Leaf Green
 static const Color accentLavender = Color(0xFF82A37D); // Sage Accent
 static const Color softCream = Color(0xFFF7EFE1); // Soft Milk Cream Background
 static const Color sandBeige = Color(0xFFE6D3B3); // Warm Sand
 static const Color mintFresh = Color(0xFF82A37D); // Leaf Green
 static const Color warmSun = Color(0xFFF0D5C0); // Warm Sand Sunset
 
 // Neutral Palette
 static const Color darkText = Color(0xFF2E332F); // Deep Charcoal Forest
 static const Color subText = Color(0xFF6B726B); // Muted Sage Grey
 static const Color cardBg = Color(0xFFFFFFFF);
 static const Color borderSoft = Color(0xFFE5D5C5);
 
 // Status Colors
 static const Color successGreen = Color(0xFF82A37D);
 static const Color warningOrange = Color(0xFFE08D64);

 static ThemeData get lightTheme {
 return ThemeData(
 useMaterial3: true,
 scaffoldBackgroundColor: softCream,
 colorScheme: ColorScheme.light(
 primary: primaryRose,
 secondary: sageGreen,
 tertiary: sandBeige,
 surface: cardBg,
 onSurface: darkText,
 onPrimary: Colors.white,
 ),
 textTheme: TextTheme(
 displayLarge: GoogleFonts.fredoka(
 fontSize: 32,
 fontWeight: FontWeight.bold,
 color: darkText,
 ),
 headlineMedium: GoogleFonts.fredoka(
 fontSize: 24,
 fontWeight: FontWeight.w600,
 color: darkText,
 ),
 titleLarge: GoogleFonts.fredoka(
 fontSize: 20,
 fontWeight: FontWeight.w600,
 color: darkText,
 ),
 bodyLarge: GoogleFonts.quicksand(
 fontSize: 16,
 fontWeight: FontWeight.w700,
 color: darkText,
 ),
 bodyMedium: GoogleFonts.quicksand(
 fontSize: 14,
 fontWeight: FontWeight.w600,
 color: subText,
 ),
 labelLarge: GoogleFonts.fredoka(
 fontSize: 16,
 fontWeight: FontWeight.bold,
 color: Colors.white,
 ),
 ),
 cardTheme: CardThemeData(
 color: cardBg,
 elevation: 2,
 shadowColor: primaryRose.withValues(alpha: 0.12),
 shape: RoundedRectangleBorder(
 borderRadius: BorderRadius.circular(20),
 side: const BorderSide(color: borderSoft, width: 1),
 ),
 ),
 appBarTheme: AppBarTheme(
 backgroundColor: softCream,
 elevation: 0,
 centerTitle: true,
 titleTextStyle: GoogleFonts.fredoka(
 fontSize: 20,
 fontWeight: FontWeight.bold,
 color: darkText,
 ),
 iconTheme: const IconThemeData(color: darkText),
 ),
 bottomNavigationBarTheme: BottomNavigationBarThemeData(
 backgroundColor: Colors.white,
 selectedItemColor: primaryRose,
 unselectedItemColor: subText,
 selectedLabelStyle: GoogleFonts.fredoka(fontWeight: FontWeight.bold, fontSize: 12),
 unselectedLabelStyle: GoogleFonts.quicksand(fontWeight: FontWeight.w600, fontSize: 12),
 type: BottomNavigationBarType.fixed,
 elevation: 8,
 ),
 elevatedButtonTheme: ElevatedButtonThemeData(
 style: ElevatedButton.styleFrom(
 backgroundColor: primaryRose,
 foregroundColor: Colors.white,
 elevation: 2,
 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
 shape: RoundedRectangleBorder(
 borderRadius: BorderRadius.circular(30),
 ),
 textStyle: GoogleFonts.fredoka(
 fontSize: 16,
 fontWeight: FontWeight.bold,
 ),
 ),
 ),
 );
 }
}
