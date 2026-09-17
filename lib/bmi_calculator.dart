import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const BmiCalculatorApp());
}

class BmiCalculatorApp extends StatelessWidget {
  const BmiCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1D1E33),
        ),
      ),
      home: const BmiHomePage(),
    );
  }
}

class BmiHomePage extends StatefulWidget {
  const BmiHomePage({super.key});

  @override
  State<BmiHomePage> createState() => _BmiHomePageState();
}

class _BmiHomePageState extends State<BmiHomePage> {
  int height = 176;
  int weight = 60;
  int age = 23;
  bool isMaleSelected = true;

  // Function to calculate BMI and show results
  void calculateAndShowBmi() {
    // BMI Formula: weight (kg) / [height (m)]^2
    double heightInMeters = height / 100;
    double bmi = weight / pow(heightInMeters, 2);
    String bmiResult = bmi.toStringAsFixed(1);
    
    String resultText;
    String interpretation;

    if (bmi >= 25) {
      resultText = 'Overweight';
      interpretation = 'You have a higher than normal body weight. Try to exercise more.';
    } else if (bmi >= 18.5) {
      resultText = 'Normal';
      interpretation = 'You have a normal body weight. Good job!';
    } else {
      resultText = 'Underweight';
      interpretation = 'You have a lower than normal body weight. You can eat a bit more.';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D1E33),
        title: const Text('YOUR RESULT', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(resultText.toUpperCase(), style: const TextStyle(color: Color(0xFF24D876), fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(bmiResult, style: const TextStyle(fontSize: 60, fontWeight: FontWeight.w900, color: Colors.white)),
            const SizedBox(height: 10),
            Text(interpretation, style: const TextStyle(fontSize: 16, color: Colors.white70)),
            const SizedBox(height: 10),
            Text('Gender: ${isMaleSelected ? "Male" : "Female"} | Age: $age', style: const TextStyle(color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('RE-CALCULATE', style: TextStyle(color: Color(0xFFEB1555), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'BMI CALCULATOR',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Gender Selection Row (Clickable)
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isMaleSelected = true;
                      });
                    },
                    child: ReusableCard(
                      color: isMaleSelected ? const Color(0xFF1D1E33) : const Color(0xFF111328),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.male, size: 80.0, color: Colors.white),
                          SizedBox(height: 15.0),
                          Text('MALE', style: TextStyle(fontSize: 18.0, color: Color(0xFF8D8E98))),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isMaleSelected = false;
                      });
                    },
                    child: ReusableCard(
                      color: !isMaleSelected ? const Color(0xFF1D1E33) : const Color(0xFF111328),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.female, size: 80.0, color: Colors.white),
                          SizedBox(height: 15.0),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('HEIGHT', style: TextStyle(fontSize: 18.0, color: Color(0xFF8D8E98))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(height.toString(), style: const TextStyle(fontSize: 50.0, fontWeight: FontWeight.w900)),
                      const Text('cm', style: TextStyle(fontSize: 18.0, color: Color(0xFF8D8E98))),
                    ],
                  ),
                  Slider(
                    value: height.toDouble(),
                    min: 120.0,
                    max: 220.0,
                    activeColor: const Color(0xFFEB1555),
                    inactiveColor: const Color(0xFF8D8E98),
                    onChanged: (double newValue) {
                      setState(() {
                        height = newValue.round();
                      });
                    },
                  ),
                ],
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('WEIGHT', style: TextStyle(fontSize: 18.0, color: Color(0xFF8D8E98))),
                        Text(weight.toString(), style: const TextStyle(fontSize: 50.0, fontWeight: FontWeight.w900)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundIconButton(
                              icon: Icons.remove,
                              onPressed: () {
                                setState(() {
                                  if (weight > 1) weight--;
                                });
                              },
                            ),
                            const SizedBox(width: 10.0),
                            RoundIconButton(
                              icon: Icons.add,
                              onPressed: () {
                                setState(() {
                                  weight++;
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    color: const Color(0xFF1D1E33),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('AGE', style: TextStyle(fontSize: 18.0, color: Color(0xFF8D8E98))),
                        Text(age.toString(), style: const TextStyle(fontSize: 50.0, fontWeight: FontWeight.w900)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundIconButton(
                              icon: Icons.remove,
                              onPressed: () {
                                setState(() {
                                  if (age > 1) age--;
                                });
                              },
                            ),
                            const SizedBox(width: 10.0),
                            RoundIconButton(
                              icon: Icons.add,
                              onPressed: () {
                                setState(() {
                                  age++;
                                });
                              },
                            ),
                          ],
                        )
                      ],
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
            height: 80.0,
            child: TextButton(
              onPressed: calculateAndShowBmi,
              child: const Text(
                'CALCULATE',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
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
      margin: const EdgeInsets.all(15.0),
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
      constraints: const BoxConstraints.tightFor(width: 56.0, height: 56.0),
      shape: const CircleBorder(),
      fillColor: const Color(0xFF4C4F5E),
      onPressed: onPressed,
      child: Icon(icon, color: Colors.white),
    );
  }
}
