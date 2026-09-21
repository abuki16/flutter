import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_market_app/bmi_calculator.dart';
import 'bmicalculator_event.dart';
import 'bmicalculator_state.dart';

void main() {
  runApp(const BmiCalculatorApp());
}

class BmiCalculatorBloc extends Bloc<BmiCalculatorEvent, BmiCalculatorState> {
  BmiCalculatorBloc() : super(const BmiCalculatorState()) {
    on<GenderChangedEvent>((event, emit) {
      emit(state.copyWith(isMaleSelected: event.isMale));
    });

    on<HeightChangedEvent>((event, emit) {
      emit(state.copyWith(height: event.height));
    });

    on<WeightIncrementedEvent>((event, emit) {
      emit(state.copyWith(weight: state.weight + 1));
    });

    on<WeightDecrementedEvent>((event, emit) {
      if (state.weight > 1) {
        emit(state.copyWith(weight: state.weight - 1));
      }
    });

    on<AgeIncrementedEvent>((event, emit) {
      emit(state.copyWith(age: state.age + 1));
    });

    on<AgeDecrementedEvent>((event, emit) {
      if (state.age > 1) {
        emit(state.copyWith(age: state.age - 1));
      }
    });

    on<CalculateBmiEvent>((event, emit) {
      emit(state.copyWith());
    });
  }
}
