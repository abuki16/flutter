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
      debugShowCheckedModeBanner: false,
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

  // Function to calculate BMI and show the result dialog
  void calculateAndShowBmi() {
    // 1. Calculate BMI: weight (kg) / [height (m)]^2
    double heightInMeters = height / 100;
    double bmi = weight / pow(heightInMeters, 2);
    String bmiResult = bmi.toStringAsFixed(1);

    // 2. Determine standard BMI category, theme color, and advice
    String resultCategory;
    Color resultColor;
    String interpretation;

    if (bmi >= 30) {
      resultCategory = 'Obese';
      resultColor = const Color(0xFFFF5252);
      interpretation = 'Your BMI is in the obese range. Regular exercise and a balanced diet are recommended.';
    } else if (bmi >= 25) {
      resultCategory = 'Overweight';
      resultColor = const Color(0xFFFFB74D);
      interpretation = 'You have a higher than normal body weight. Try to increase your daily physical activity.';
    } else if (bmi >= 18.5) {
      resultCategory = 'Normal';
      resultColor = const Color(0xFF24D876);
      interpretation = 'You have a healthy and normal body weight. Great job!';
    } else {
      resultCategory = 'Underweight';
      resultColor = const Color(0xFFFFD54F);
      interpretation = 'You have a lower than normal body weight. You can eat a bit more nutritious food.';
    }

    // 3. Calculate healthy weight range for height (WHO standard: BMI 18.5 - 24.9)
    double minHealthyWeight = 18.5 * pow(heightInMeters, 2);
    double maxHealthyWeight = 24.9 * pow(heightInMeters, 2);

    // 4. Show friendly, well-designed result popup
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                '${isMaleSelected ? "Male" : "Female"} • $age yrs',
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
                color: resultColor.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: resultColor, width: 1.5),
              ),
              child: Text(
                resultCategory.toUpperCase(),
                style: TextStyle(
                  color: resultColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Large BMI number
            Text(
              bmiResult,
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
                interpretation,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.white70, height: 1.3),
              ),
            ),
            const SizedBox(height: 12),
            // Healthy weight range note
            Text(
              'Normal weight for ${height}cm: ${minHealthyWeight.toStringAsFixed(1)} - ${maxHealthyWeight.toStringAsFixed(1)} kg',
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
              onPressed: () => Navigator.pop(context),
              child: const Text('RE-CALCULATE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
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
                        setState(() {
                          isMaleSelected = true;
                        });
                      },
                      child: ReusableCard(
                        color: isMaleSelected ? const Color(0xFF1D1E33) : const Color(0xFF111328),
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
                        setState(() {
                          isMaleSelected = false;
                        });
                      },
                      child: ReusableCard(
                        color: !isMaleSelected ? const Color(0xFF1D1E33) : const Color(0xFF111328),
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
                onPressed: calculateAndShowBmi,
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
