import 'package:equatable/equatable.dart';

class MultiplicationExercise extends Equatable {
  final int multiplicand;
  final int multiplier;
  final int product;
  const MultiplicationExercise(
      {required this.multiplicand,
      required this.multiplier,
      required this.product});

  @override
  List<Object> get props => [multiplicand, multiplier, product];
}
