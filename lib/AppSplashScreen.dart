// ignore_for_file: file_names, depend_on_referenced_packages


import 'package:dog_breed_classifier/Home.dart';
import 'package:flutter/material.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';

class AppSplashScreen extends StatefulWidget {
  const AppSplashScreen({super.key});

  @override
  State<AppSplashScreen> createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends State<AppSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return  EasySplashScreen(
      logo: Image.asset('assets/Dog Paw.png', 
      height: MediaQuery.of(context).size.height,
      width:  MediaQuery.of(context).size.width,
      ),
      title:const Text(
        "Dog Breed Classifier",
        style: TextStyle(
          fontSize: 24,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: const Color(0xFF5a869f),
      showLoader: true,
      loadingText: const Text("Loading..."),
      navigator: const Home(),
      durationInSeconds: 5,
    );
  }
}