import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lograt/app.dart';
import 'package:lograt/presentation/screens/splash_screen/splash_screen_widget.dart';

class SplashScreenState extends State<SplashScreenWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 1, milliseconds: 500), () {
      Navigator.pushNamed(context, App.workoutHistory);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SvgPicture.asset(
          'assets/icons/lograt_icon.svg',
          semanticsLabel: 'Lograt Icon',
          width: 300,
          height: 300,
        ),
      ),
    );
  }
}
