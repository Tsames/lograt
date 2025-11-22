import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/app.dart';
import 'package:lograt/data/providers.dart';

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

  // Seed Database if running in debug or profile
  if (kDebugMode || kProfileMode) {
    final container = ProviderContainer();
    final seedWorkouts = container.read(seedDataUsecaseProvider);

    await seedWorkouts();

    container.dispose();
  }

  runApp(ProviderScope(child: const App()));
}
