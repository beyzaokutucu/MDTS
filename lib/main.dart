import 'package:flutter/material.dart';
import 'package:dts/sayfalar/oturum/giris.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home:
          const LoginScreen(), // AnaSayfa widget'ını doğrudan home olarak kullan
    );
  }
}
