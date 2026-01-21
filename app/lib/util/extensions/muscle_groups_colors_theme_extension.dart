import 'package:flutter/material.dart';

@immutable
class MuscleGroupColorsThemeExtension
    extends ThemeExtension<MuscleGroupColorsThemeExtension> {
  const MuscleGroupColorsThemeExtension({
    required this.chest,
    required this.shoulders,
    required this.arms,
    required this.back,
    required this.core,
    required this.legs,
    required this.misc,
    required this.muscleGroupText,
  });

  const MuscleGroupColorsThemeExtension.light()
    : this(
        chest: const Color(0xFF733D3B),
        shoulders: const Color(0xFF9E6F3C),
        arms: const Color(0xFF887634),
        back: const Color(0xFF3F7135),
        core: const Color(0xFF2A4B65),
        legs: const Color(0xFF492D60),
        misc: const Color(0xFF2E2D2D),
        muscleGroupText: Colors.white,
      );

  const MuscleGroupColorsThemeExtension.dark()
    : this(
        chest: const Color(0xFF733D3B),
        shoulders: const Color(0xFF9E6F3C),
        arms: const Color(0xFF887634),
        back: const Color(0xFF3F7135),
        core: const Color(0xFF2A4B65),
        legs: const Color(0xFF492D60),
        misc: const Color(0xFF2E2D2D),
        muscleGroupText: Colors.white,
      );

  final Color chest;
  final Color shoulders;
  final Color arms;
  final Color back;
  final Color core;
  final Color legs;
  final Color misc;
  final Color muscleGroupText;

  @override
  MuscleGroupColorsThemeExtension copyWith({
    Color? shoulders,
    Color? arms,
    Color? back,
    Color? chest,
    Color? core,
    Color? legs,
    Color? misc,
    Color? muscleGroupText,
  }) {
    return MuscleGroupColorsThemeExtension(
      shoulders: shoulders ?? this.shoulders,
      arms: arms ?? this.arms,
      back: back ?? this.back,
      chest: chest ?? this.chest,
      core: core ?? this.core,
      legs: legs ?? this.legs,
      misc: misc ?? this.misc,
      muscleGroupText: muscleGroupText ?? this.muscleGroupText,
    );
  }

  @override
  MuscleGroupColorsThemeExtension lerp(
    MuscleGroupColorsThemeExtension? other,
    double interpolationFactor,
  ) {
    return MuscleGroupColorsThemeExtension(
      shoulders: Color.lerp(shoulders, other?.shoulders, interpolationFactor)!,
      arms: Color.lerp(arms, other?.arms, interpolationFactor)!,
      back: Color.lerp(back, other?.back, interpolationFactor)!,
      chest: Color.lerp(chest, other?.chest, interpolationFactor)!,
      core: Color.lerp(core, other?.core, interpolationFactor)!,
      legs: Color.lerp(legs, other?.legs, interpolationFactor)!,
      misc: Color.lerp(misc, other?.misc, interpolationFactor)!,
      muscleGroupText: Color.lerp(
        muscleGroupText,
        other?.muscleGroupText,
        interpolationFactor,
      )!,
    );
  }
}
