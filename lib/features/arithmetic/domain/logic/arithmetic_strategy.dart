abstract class ArithmeticStrategy {
  String get symbol;
  int calculate(int operand1, int operand2);
}

class MultiplicationStrategy implements ArithmeticStrategy {
  @override
  String get symbol => '×';

  @override
  int calculate(int operand1, int operand2) => operand1 * operand2;
}

class AdditionStrategy implements ArithmeticStrategy {
  @override
  String get symbol => '+';

  @override
  int calculate(int operand1, int operand2) => operand1 + operand2;
}
