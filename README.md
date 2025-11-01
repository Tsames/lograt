# Lograt

A mobile app designed for fitness and data enthusiasts to easily track their strength training progress.
Lograt provides a clean, simple interface designed to make logging your workout painless.

## Features

- Log workouts with exercises, sets, reps, weight, and rest times
- Support for different set types (warm-up, working, drop set, to failure)
- Flexible units (pounds/kilograms)
- View workouts logged in the current week or your entire workout history

## Planned Features

- Workout templates
- Progress visualization
- Tags
- Filters for workout history and other views
- Personal record highlights

## Architecture

Clean Architecture with MVVM:

- **Domain**: Entities (Workout, Exercise, ExerciseSet, ExerciseType) and use cases
- **Data**: Repository pattern with DAOs for database operations
- **Presentation**: Flutter UI with Riverpod state management

## Tech Stack

- Flutter & Dart
- SQLite (sqflite)
- Riverpod for dependency injection and state management