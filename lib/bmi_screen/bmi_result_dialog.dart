import 'package:flutter/material.dart';
import 'package:mini_market_app/bmi_bloc/bmicalculator_state.dart';

void showBmiResultDialog(BuildContext context, BmiCalculatorState state) {
  showDialog(
    context: context,
    builder: (dialogCtx) => AlertDialog(
      backgroundColor: const Color(0xFF1D1E33),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'YOUR RESULT',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF111328),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${state.isMaleSelected ? "Male" : "Female"} • ${state.age} yrs',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          // Category Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: state.resultColor.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: state.resultColor, width: 1.5),
            ),
            child: Text(
              state.resultCategory.toUpperCase(),
              style: TextStyle(
                color: state.resultColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 15),
          // Large BMI number
          Text(
            state.bmiResult,
            style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          const Text('BMI (kg/m²)', style: TextStyle(color: Color(0xFF8D8E98), fontSize: 13)),
          const SizedBox(height: 15),
          // Interpretation Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0E21),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              state.interpretation,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.white70, height: 1.3),
            ),
          ),
          const SizedBox(height: 12),
          // Healthy weight range note
          Text(
            'Normal weight for ${state.height}cm: ${state.minHealthyWeight.toStringAsFixed(1)} - ${state.maxHealthyWeight.toStringAsFixed(1)} kg',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEB1555),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text(
              'RE-CALCULATE',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ],
    ),
  );
}
