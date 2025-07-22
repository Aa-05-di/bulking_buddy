import 'package:first_pro/presentations/login.dart';
import 'package:first_pro/presentations/userpage.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Bulking Buddy",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home:Login(),
    );
  }
}