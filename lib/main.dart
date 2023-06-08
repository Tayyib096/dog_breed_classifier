import 'package:dog_breed_classifier/AppSplashScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
 theme:
ThemeData(
    primaryColor:const Color(0xFF5a869f),  //Colors.amber.shade900,
    
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: const Color(0xFF5a869f),
    ),

     elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, 
      ),
    ),
    textTheme:
    const TextTheme(
      bodyText2:  TextStyle(color: Colors.black, fontSize: 24),
    ),
    appBarTheme:const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            foregroundColor: Colors.white,
    ),
  ),
      debugShowCheckedModeBanner: false,
      home: const AppSplashScreen(),
    );
  }
}

