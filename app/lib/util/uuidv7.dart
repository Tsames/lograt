import 'dart:math';

import 'package:uuidv7/uuidv7.dart';

late final _randomForUuidV7 = Random();

String uuidV7() => generateUuidV7String(_randomForUuidV7);
