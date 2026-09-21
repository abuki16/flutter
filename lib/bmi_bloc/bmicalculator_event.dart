abstract class BmiCalculatorEvent {
  const BmiCalculatorEvent();
}

class GenderChangedEvent extends BmiCalculatorEvent {
  final bool isMale;
  const GenderChangedEvent(this.isMale);
}

class HeightChangedEvent extends BmiCalculatorEvent {
  final int height;
  const HeightChangedEvent(this.height);
}

class WeightIncrementedEvent extends BmiCalculatorEvent {
  const WeightIncrementedEvent();
}

class WeightDecrementedEvent extends BmiCalculatorEvent {
  const WeightDecrementedEvent();
}

class AgeIncrementedEvent extends BmiCalculatorEvent {
  const AgeIncrementedEvent();
}

class AgeDecrementedEvent extends BmiCalculatorEvent {
  const AgeDecrementedEvent();
}

class CalculateBmiEvent extends BmiCalculatorEvent {
  const CalculateBmiEvent();
}
