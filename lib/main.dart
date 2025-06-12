import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lograt/database/app_database.dart';
import 'package:lograt/repository/services/app_database.dart';
import 'package:lograt/routes/home/home.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();

  runApp(const LogRatApp());
}

class LogRatApp extends StatelessWidget {
  const LogRatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Lograt', home: Home());
  }
}
