import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_market_app/bmi_bloc/bmicalculator_bloc.dart';
import 'package:mini_market_app/bmi_screen/bmi_screen.dart';

void main() {
  runApp(const BmiCalculatorApp());
}

class BmiCalculatorApp extends StatelessWidget {
  const BmiCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BmiCalculatorBloc(),
      child: MaterialApp(
        title: 'BMI Calculator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF0A0E21),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1D1E33),
          ),
        ),
        home: const BmiScreen(),
      ),
    );
  }
}
