import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lograt/di/service_locator.dart';
import 'package:lograt/pages/home/home.dart';

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
  await setupServiceLocator();

  runApp(const LogRatApp());
}

class LogRatApp extends StatelessWidget {
  const LogRatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Lograt', home: Home());
  }
}
