import 'package:flutter_test/flutter_test.dart';
import 'package:mini_market_app/bmi_bloc/bmicalculator_bloc.dart';
import 'package:mini_market_app/bmi_bloc/bmicalculator_event.dart';

void main() {
  group('BmiCalculatorBloc', () {
    late BmiCalculatorBloc bloc;

    setUp(() {
      bloc = BmiCalculatorBloc();
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state has correct default values and calculations', () {
      expect(bloc.state.height, 176);
      expect(bloc.state.weight, 60);
      expect(bloc.state.age, 23);
      expect(bloc.state.isMaleSelected, isTrue);
      expect(bloc.state.bmiResult, '19.4');
      expect(bloc.state.resultCategory, 'Normal');
    });

    test('emits updated isMaleSelected when GenderChangedEvent is added', () async {
      bloc.add(const GenderChangedEvent(false));
      await expectLater(
        bloc.stream,
        emits(predicate<dynamic>((state) => state.isMaleSelected == false)),
      );
    });

    test('emits updated height when HeightChangedEvent is added', () async {
      bloc.add(const HeightChangedEvent(180));
      await expectLater(
        bloc.stream,
        emits(predicate<dynamic>((state) => state.height == 180)),
      );
    });

    test('increments and decrements weight accurately', () async {
      bloc.add(const WeightIncrementedEvent());
      await expectLater(
        bloc.stream,
        emits(predicate<dynamic>((state) => state.weight == 61)),
      );

      bloc.add(const WeightDecrementedEvent());
      await expectLater(
        bloc.stream,
        emits(predicate<dynamic>((state) => state.weight == 60)),
      );
    });

    test('increments and decrements age accurately', () async {
      bloc.add(const AgeIncrementedEvent());
      await expectLater(
        bloc.stream,
        emits(predicate<dynamic>((state) => state.age == 24)),
      );

      bloc.add(const AgeDecrementedEvent());
      await expectLater(
        bloc.stream,
        emits(predicate<dynamic>((state) => state.age == 23)),
      );
    });
  });
}
