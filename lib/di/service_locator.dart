// lib/di/service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:lograt/di/repository_module.dart';

import 'database_module.dart';

// Global access point for our dependency injection container
final GetIt serviceLocator = GetIt.instance;

// This function sets up all our dependencies
Future<void> setupServiceLocator() async {
  await setupDatabaseModule();
  setupRepositoryModule();
}
