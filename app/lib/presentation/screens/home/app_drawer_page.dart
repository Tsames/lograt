import 'package:flutter/material.dart';

abstract class AppDrawerPage {
  String get appBarTitle;

  String get drawerTitle;

  IconData get icon;

  // Todo: add support for svgs
  // String? get iconSvgAssetPath => null;
  // String? get iconSvgSemanticsLabel => null;

  Widget get page;
}
