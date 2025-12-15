import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tap_and_learn/main.dart' as app;
import 'package:get_it/get_it.dart';
import 'package:tap_and_learn/features/arithmetic/presentation/widgets/keypad.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  Finder findKey(String key) {
    return find.descendant(
      of: find.byType(Keypad),
      matching: find.text(key),
    );
  }

  void expectDisplay(WidgetTester tester, String text) {
    expect(find.byKey(const Key('display_output')), findsOneWidget);
    expect(
        tester.widget<Text>(find.byKey(const Key('display_output'))).data, text);
  }

  // Helper to slow down execution for visual observation
  Future<void> slowDown(WidgetTester tester, [int milliseconds = 500]) async {
    final int steps = milliseconds ~/ 50;
    for (int i = 0; i < steps; i++) {
      await tester.pump(const Duration(milliseconds: 50)); // Advance logical clock
      await Future.delayed(const Duration(milliseconds: 50)); // Wait real time
    }
  }

  group('App Integration Tests', () {
    setUp(() async {
      await GetIt.instance.reset();
    });

    testWidgets('Full flow test', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await slowDown(tester, 1000); // Wait for app launch

      final infoButton = find.byIcon(Icons.info_outline_rounded);
      expect(infoButton, findsOneWidget);

      await tester.tap(infoButton);
      await tester.pumpAndSettle();
      await slowDown(tester); // View dialog

      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await slowDown(tester);

      expect(find.byType(AlertDialog), findsNothing);

      final questionFinder = find.byKey(const Key('display_output'));
      expect(questionFinder, findsOneWidget);

      final questionText = tester.widget<Text>(questionFinder).data!;
      final parts = questionText.split(' × ');
      expect(parts.length, 2, reason: 'Question format should be A × B');

      final operand1 = int.parse(parts[0]);
      final operand2 = int.parse(parts[1]);
      final product = operand1 * operand2;
      final productStr = product.toString();

      // print('Found question: $questionText, Expected answer: $productStr');

      for (var char in productStr.split('')) {
        await tester.tap(findKey(char));
        await tester.pump(); // Advance frame
        await slowDown(tester, 300); // Real-time delay for typing effect
      }

      await tester.pump();
      expectDisplay(tester, productStr);
      await slowDown(tester, 1000); // View result

      await tester.pumpAndSettle(const Duration(seconds: 2)); // Wait for app logic (virtual time)
      await slowDown(tester); // Real time wait to see new question

      expect(find.textContaining('×'), findsOneWidget);
      final newQuestionText =
          tester.widget<Text>(find.byKey(const Key('display_output'))).data!;
      // print('New question: $newQuestionText');

      // Parse new question to check if we can test backspace
      final newParts = newQuestionText.split(' × ');
      final newOperand1 = int.parse(newParts[0]);
      final newOperand2 = int.parse(newParts[1]);
      final newProductLength = (newOperand1 * newOperand2).toString().length;

      // Only test backspace if typing '1' won't trigger immediate validation (i.e., product length > 1)
      // Also ensure '1' isn't the start of the correct answer if we care (but here we just want to see '1')
      if (newProductLength > 1) {
        await tester.tap(findKey('1'));
        await tester.pump();
        await slowDown(tester);

        expectDisplay(tester, '1');

        await tester.tap(find.byIcon(Icons.backspace_rounded));
        await tester.pump();
        await slowDown(tester);

        expectDisplay(tester, newQuestionText);
      } else {
        // print(
        //     'Skipping backspace test because product length is 1 (Question: $newQuestionText)');
      }

      final settingsButton = find.byIcon(Icons.settings);
      await tester.tap(settingsButton);
      await tester.pumpAndSettle();
      await slowDown(tester);

      await tester.tap(find.byKey(const ValueKey('operand1_5')));
      await tester.pump();
      await slowDown(tester);

      await tester.tap(find.byKey(const ValueKey('apply_button')));
      await tester.pumpAndSettle();
      await slowDown(tester);
    });

    testWidgets('Incorrect answer feedback', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await slowDown(tester, 1000);

      final questionFinder = find.byKey(const Key('display_output'));
      expect(questionFinder, findsOneWidget);
      final questionText = tester.widget<Text>(questionFinder).data!;

      final parts = questionText.split(' × ');
      final a = int.parse(parts[0]);
      final b = int.parse(parts[1]);
      final correctProduct = a * b;

      // Calculate a wrong answer with the SAME length as the correct answer
      String wrongAnswerStr = (correctProduct + 1).toString();
      if (wrongAnswerStr.length != correctProduct.toString().length) {
        wrongAnswerStr = (correctProduct - 1).toString();
      }

      // print(
      //     'Question: $questionText, Correct: $correctProduct, Inputting Wrong: $wrongAnswerStr');

      for (var char in wrongAnswerStr.split('')) {
        await tester.tap(findKey(char));
        await tester.pump();
        await slowDown(tester, 300);
      }

      expectDisplay(tester, questionText);

      final textWidget =
          tester.widget<Text>(find.byKey(const Key('display_output')));
      expect(textWidget.style?.color, Colors.red);
      await slowDown(tester, 1000); // See red text

      await tester.pumpAndSettle(const Duration(seconds: 2)); // Virtual wait for reset
      await slowDown(tester); // Real time wait

      expectDisplay(tester, questionText);

      final textWidgetReset =
          tester.widget<Text>(find.byKey(const Key('display_output')));
      expect(textWidgetReset.style?.color, isNot(Colors.red));
    });
  });
}
