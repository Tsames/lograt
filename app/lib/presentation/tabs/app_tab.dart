import 'package:flutter/material.dart';

abstract class AppTab {
  String get title;

  IconData get icon;

  Widget get widget;
}
