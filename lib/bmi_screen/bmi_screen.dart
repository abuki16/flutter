import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_market_app/bmi_bloc/bmicalculator_bloc.dart';
import 'package:mini_market_app/bmi_bloc/bmicalculator_event.dart';
import 'package:mini_market_app/bmi_bloc/bmicalculator_state.dart';
import 'package:mini_market_app/bmi_calculator.dart';
import 'package:mini_market_app/bmi_screen/bmi_result_dialog.dart';

void main() {
  runApp(const BmiCalculatorApp());
}

class BmiScreen extends StatelessWidget {
  const BmiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BmiCalculatorBloc, BmiCalculatorState>(
      builder: (context, state) {
        final bloc = context.read<BmiCalculatorBloc>();

        return Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text(
                'BMI CALCULATOR',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Gender Selection Row (Clickable)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            bloc.add(const GenderChangedEvent(true));
                          },
                          child: ReusableCard(
                            color: state.isMaleSelected
                                ? const Color(0xFF1D1E33)
                                : const Color(0xFF111328),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.male, size: 70.0, color: Colors.white),
                                SizedBox(height: 10.0),
                                Text('MALE', style: TextStyle(fontSize: 18.0, color: Color(0xFF8D8E98))),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            bloc.add(const GenderChangedEvent(false));
                          },
                          child: ReusableCard(
                            color: !state.isMaleSelected
                                ? const Color(0xFF1D1E33)
                                : const Color(0xFF111328),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.female, size: 70.0, color: Colors.white),
                                SizedBox(height: 10.0),
                                Text('FEMALE', style: TextStyle(fontSize: 18.0, color: Color(0xFF8D8E98))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Height Slider Card
                Expanded(
                  child: ReusableCard(
                    color: const Color(0xFF1D1E33),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('HEIGHT', style: TextStyle(fontSize: 18.0, color: Color(0xFF8D8E98))),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(state.height.toString(), style: const TextStyle(fontSize: 50.0, fontWeight: FontWeight.w900)),
                              const Text('cm', style: TextStyle(fontSize: 18.0, color: Color(0xFF8D8E98))),
                            ],
                          ),
                          Slider(
                            value: state.height.toDouble(),
                            min: 120.0,
                            max: 220.0,
                            activeColor: const Color(0xFFEB1555),
                            inactiveColor: const Color(0xFF8D8E98),
                            onChanged: (double newValue) {
                              bloc.add(HeightChangedEvent(newValue.round()));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 3. Weight and Age Counters Row (+ and - buttons functional)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ReusableCard(
                          color: const Color(0xFF1D1E33),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('WEIGHT', style: TextStyle(fontSize: 18.0, color: Color(0xFF8D8E98))),
                                Text(state.weight.toString(), style: const TextStyle(fontSize: 50.0, fontWeight: FontWeight.w900)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RoundIconButton(
                                      icon: Icons.remove,
                                      onPressed: () {
                                        bloc.add(const WeightDecrementedEvent());
                                      },
                                    ),
                                    const SizedBox(width: 10.0),
                                    RoundIconButton(
                                      icon: Icons.add,
                                      onPressed: () {
                                        bloc.add(const WeightIncrementedEvent());
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ReusableCard(
                          color: const Color(0xFF1D1E33),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('AGE', style: TextStyle(fontSize: 18.0, color: Color(0xFF8D8E98))),
                                Text(state.age.toString(), style: const TextStyle(fontSize: 50.0, fontWeight: FontWeight.w900)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RoundIconButton(
                                      icon: Icons.remove,
                                      onPressed: () {
                                        bloc.add(const AgeDecrementedEvent());
                                      },
                                    ),
                                    const SizedBox(width: 10.0),
                                    RoundIconButton(
                                      icon: Icons.add,
                                      onPressed: () {
                                        bloc.add(const AgeIncrementedEvent());
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 4. Calculate Button
                Container(
                  color: const Color(0xFFEB1555),
                  margin: const EdgeInsets.only(top: 10.0),
                  width: double.infinity,
                  height: 65.0,
                  child: TextButton(
                    onPressed: () {
                      bloc.add(const CalculateBmiEvent());
                      showBmiResultDialog(context, state);
                    },
                    child: const Text(
                      'CALCULATE',
                      style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ReusableCard extends StatelessWidget {
  const ReusableCard({super.key, required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: child,
    );
  }
}

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({super.key, required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 6.0,
      constraints: const BoxConstraints.tightFor(width: 48.0, height: 48.0),
      shape: const CircleBorder(),
      fillColor: const Color(0xFF4C4F5E),
      onPressed: onPressed,
      child: Icon(icon, color: Colors.white),
    );
  }
}
