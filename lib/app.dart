import 'package:flutter/material.dart';
import 'package:lograt/presentation/screens/home/home.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Lograt', home: Home());
  }
}
