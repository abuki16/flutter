import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_market_app/bmi_calculator.dart';
import 'package:mini_market_app/main.dart';
import 'package:mini_market_app/data/market_store.dart';
import 'package:mini_market_app/models/product.dart';

void main() {
  testWidgets('BmiCalculatorApp renders properly', (WidgetTester tester) async {
    await tester.pumpWidget(const BmiCalculatorApp());
    expect(find.text('BMI CALCULATOR'), findsOneWidget);
    expect(find.text('MALE'), findsOneWidget);
    expect(find.text('FEMALE'), findsOneWidget);
    expect(find.text('CALCULATE'), findsOneWidget);
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

  testWidgets('MyApp renders home screen with product catalog', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Mini Market'), findsOneWidget);
    expect(find.text('Phone X'), findsOneWidget);
    expect(find.text('Headphones'), findsOneWidget);
  });

  testWidgets('MyApp renders empty state when no products exist', (WidgetTester tester) async {
    // Clear products to simulate empty state
    final backup = List<Product>.from(MarketStore.products);
    MarketStore.products.clear();

    await tester.pumpWidget(const MyApp());
    expect(find.text('No products yet.\nTap + to add your first one.'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Restore products
    MarketStore.products.addAll(backup);
  });
}
