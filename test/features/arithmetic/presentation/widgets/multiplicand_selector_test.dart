import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tap_and_learn/config/theme/app_colors.dart';
import 'package:tap_and_learn/features/arithmetic/presentation/widgets/multiplicand_selector/cubit/multiplicand_config_cubit.dart';
import 'package:tap_and_learn/features/arithmetic/presentation/widgets/multiplicand_selector/multiplicand_selector.dart';
import 'package:tap_and_learn/l10n/app_localizations.dart';

class MockMultiplicandConfigCubit extends MockCubit<MultiplicandConfigState>
    implements MultiplicandConfigCubit {}

void main() {
  late MockMultiplicandConfigCubit mockCubit;

  setUp(() {
    mockCubit = MockMultiplicandConfigCubit();
  });

  testWidgets('MultiplicandSelector opens menu and interacts with cubit',
      (WidgetTester tester) async {
    // Stub the state
    const initialState = MultiplicandConfigState(
      selectedMultiplicands: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    );
    whenListen(
      mockCubit,
      Stream.value(initialState),
      initialState: initialState,
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          extensions: const [
            GameThemeColors(
              numberBtnColor1: GamePalette.yellow,
              numberBtnColor2: GamePalette.blue,
              numberBtnColor3: GamePalette.orange,
              deleteBtnColor: GamePalette.red,
              textMainColor: GamePalette.textMain,
            ),
          ],
        ),
        home: Scaffold(
          body: BlocProvider<MultiplicandConfigCubit>.value(
            value: mockCubit,
            child: const MultiplicandSelector(),
          ),
        ),
      ),
    );

    // Verify initial state: Menu is closed
    expect(find.byIcon(Icons.settings), findsOneWidget);

    // Open the menu
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    // Verify menu is open
    expect(find.text('1'), findsOneWidget);

    // Tap on item '1' using text. Initially selected, so it should be unselected in temp state.
    await tester.tap(find.widgetWithText(MenuItemButton, '1'));
    await tester.pump();

    // Verify toggleMultiplicand was NOT called (changes are local)
    verifyNever(() => mockCubit.toggleMultiplicand(any()));
    verifyNever(() => mockCubit.updateMultiplicands(any()));

    // Verify visual update (checkmark should be gone)
    expect(find.text('APPLY'), findsOneWidget);

    // Tap Apply
    await tester.tap(find.text('APPLY'));
    await tester.pumpAndSettle();

    // Verify updateMultiplicands was called with expected list (1 removed from 0-9)
    // [0, 2, 3, 4, 5, 6, 7, 8, 9]
    final expected = [0, 2, 3, 4, 5, 6, 7, 8, 9];
    verify(() => mockCubit.updateMultiplicands(expected)).called(1);

    // Verify menu closed
    expect(find.text('APPLY'), findsNothing);
  });
}