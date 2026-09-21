import 'dart:math';
import 'package:flutter/material.dart';

class BmiCalculatorState {
  final int height;
  final int weight;
  final int age;
  final bool isMaleSelected;

  const BmiCalculatorState({
    this.height = 176,
    this.weight = 60,
    this.age = 23,
    this.isMaleSelected = true,
  });

  // Calculate BMI: weight (kg) / [height (m)]^2
  double get bmi {
    final double heightInMeters = height / 100;
    return weight / pow(heightInMeters, 2);
  }

  String get bmiResult => bmi.toStringAsFixed(1);

  String get resultCategory {
    if (bmi >= 30) {
      return 'Obese';
    } else if (bmi >= 25) {
      return 'Overweight';
    } else if (bmi >= 18.5) {
      return 'Normal';
    } else {
      return 'Underweight';
    }
  }

  Color get resultColor {
    if (bmi >= 30) {
      return const Color(0xFFFF5252);
    } else if (bmi >= 25) {
      return const Color(0xFFFFB74D);
    } else if (bmi >= 18.5) {
      return const Color(0xFF24D876);
    } else {
      return const Color(0xFFFFD54F);
    }
  }

  String get interpretation {
    if (bmi >= 30) {
      return 'Your BMI is in the obese range. Regular exercise and a balanced diet are recommended.';
    } else if (bmi >= 25) {
      return 'You have a higher than normal body weight. Try to increase your daily physical activity.';
    } else if (bmi >= 18.5) {
      return 'You have a healthy and normal body weight. Great job!';
    } else {
      return 'You have a lower than normal body weight. You can eat a bit more nutritious food.';
    }
  }

  double get minHealthyWeight {
    final double heightInMeters = height / 100;
    return 18.5 * pow(heightInMeters, 2);
  }

  double get maxHealthyWeight {
    final double heightInMeters = height / 100;
    return 24.9 * pow(heightInMeters, 2);
  }

  BmiCalculatorState copyWith({
    int? height,
    int? weight,
    int? age,
    bool? isMaleSelected,
  }) {
    return BmiCalculatorState(
      height: height ?? this.height,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      isMaleSelected: isMaleSelected ?? this.isMaleSelected,
    );
  }
}
