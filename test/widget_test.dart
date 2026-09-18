// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:abuki/bmi_calculator.dart';
import 'package:abuki/main.dart';

void main() {
  testWidgets('BmiCalculatorApp renders properly', (WidgetTester tester) async {
    await tester.pumpWidget(const BmiCalculatorApp());
    expect(find.text('BMI CALCULATOR'), findsOneWidget);
    expect(find.text('MALE'), findsOneWidget);
    expect(find.text('FEMALE'), findsOneWidget);
    expect(find.text('CALCULATE'), findsOneWidget);
  });

  testWidgets('FolderlichApp renders properly', (WidgetTester tester) async {
    await tester.pumpWidget(const FolderlichApp());
    expect(find.text('Foldrlich'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('BmiCalculatorApp calculates and displays result dialog on tap', (WidgetTester tester) async {
    await tester.pumpWidget(const BmiCalculatorApp());

    // Tap the CALCULATE button
    await tester.tap(find.text('CALCULATE'));
    await tester.pumpAndSettle();

    // Verify the result dialog displays expected elements
    expect(find.text('YOUR RESULT'), findsOneWidget);
    expect(find.text('NORMAL'), findsOneWidget);
    expect(find.text('19.4'), findsOneWidget);
    expect(find.text('RE-CALCULATE'), findsOneWidget);

    // Tap RE-CALCULATE to dismiss dialog
    await tester.tap(find.text('RE-CALCULATE'));
    await tester.pumpAndSettle();

    // Dialog dismissed, main screen visible
    expect(find.text('YOUR RESULT'), findsNothing);
    expect(find.text('CALCULATE'), findsOneWidget);
  });
}
