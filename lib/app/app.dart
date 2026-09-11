import 'package:flutter/material.dart';
import 'router.dart';
import 'theme.dart';

class BloomTaleApp extends StatelessWidget {
 const BloomTaleApp({super.key});

 @override
 Widget build(BuildContext context) {
 return MaterialApp.router(
 title: 'BloomTale',
 debugShowCheckedModeBanner: false,
 theme: BloomTheme.lightTheme,
 routerConfig: appRouter,
 );
 }
}
