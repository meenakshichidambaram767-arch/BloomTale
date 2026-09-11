import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme.dart';

class BloomLogo extends StatelessWidget {
 final double size;
 final bool showText;
 final bool isRow;
 final bool isHero;
 final TextStyle? textStyle;

 const BloomLogo({
 super.key,
 this.size = 40.0,
 this.showText = false,
 this.isRow = true,
 this.isHero = false,
 this.textStyle,
 });

 @override
 Widget build(BuildContext context) {
 final logoImage = Container(
 width: size,
 height: size,
 decoration: BoxDecoration(
 shape: BoxShape.circle,
 boxShadow: isHero
 ? [
 BoxShadow(
 color: BloomTheme.primaryRose.withValues(alpha: 0.25),
 blurRadius: 20,
 spreadRadius: 4,
 offset: const Offset(0, 8),
 ),
 BoxShadow(
 color: BloomTheme.sageGreen.withValues(alpha: 0.15),
 blurRadius: 10,
 spreadRadius: 2,
 ),
 ]
 : [
 BoxShadow(
 color: Colors.black.withValues(alpha: 0.06),
 blurRadius: 6,
 offset: const Offset(0, 2),
 ),
 ],
 ),
 child: ClipOval(
 child: Image.asset(
 'assets/images/logo.png',
 width: size,
 height: size,
 fit: BoxFit.cover,
 errorBuilder: (context, error, stackTrace) {
 return Container(
 color: BloomTheme.sandBeige,
 child: Icon(
 Icons.local_florist_rounded,
 size: size * 0.6,
 color: BloomTheme.primaryRose,
 ),
 );
 },
 ),
 ),
 );

 if (!showText) {
 return logoImage;
 }

 final titleWidget = Text(
 'BloomTale',
 style: textStyle ??
 GoogleFonts.fredoka(
 fontSize: isHero ? 36 : (size * 0.55).clamp(16.0, 24.0),
 fontWeight: FontWeight.bold,
 color: BloomTheme.darkText,
 letterSpacing: 0.5,
 ),
 );

 if (isRow) {
 return Row(
 mainAxisSize: MainAxisSize.min,
 crossAxisAlignment: CrossAxisAlignment.center,
 children: [
 logoImage,
 const SizedBox(width: 10),
 titleWidget,
 ],
 );
 }

 return Column(
 mainAxisSize: MainAxisSize.min,
 crossAxisAlignment: CrossAxisAlignment.center,
 children: [
 logoImage,
 const SizedBox(height: 12),
 titleWidget,
 ],
 );
 }
}
