import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tap_and_learn/config/theme/app_colors.dart';
import 'package:tap_and_learn/features/arithmetic/presentation/bloc/multiplication_execise_bloc.dart';
import 'package:tap_and_learn/features/arithmetic/presentation/widgets/multiplicand_selector/cubit/multiplicand_config_cubit.dart';
import 'package:tap_and_learn/features/arithmetic/presentation/widgets/keypad.dart';
import 'package:tap_and_learn/features/arithmetic/presentation/widgets/multiplicand_selector/multiplicand_selector.dart';
import 'package:tap_and_learn/injection_container.dart';
import 'package:flutter/foundation.dart';
import 'package:tap_and_learn/l10n/app_localizations.dart';

class MultiplicationTrainerScreen extends StatelessWidget {
  const MultiplicationTrainerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<MultiplicandConfigCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<MultiplicationExerciseBloc>(),
        ),
      ],
      child: const _MultiplicationTrainerView(),
    );
  }
}

class _MultiplicationTrainerView extends StatefulWidget {
  const _MultiplicationTrainerView({
    super.key,
  });

  @override
  State<_MultiplicationTrainerView> createState() =>
      _MultiplicationTrainerViewState();
}

class _MultiplicationTrainerViewState
    extends State<_MultiplicationTrainerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: BlocBuilder<MultiplicationExerciseBloc,
              MultiplicationExerciseState>(builder: (context, state) {
            return _buildScreen(context, state);
          }),
        ),
      ),
    );
  }

  Widget _buildScreen(BuildContext context, MultiplicationExerciseState state) {
    final gameColors = Theme.of(context).extension<GameThemeColors>()!;
    Color displayColor = gameColors.textMainColor!;
    if (state.status == AnswerStatus.incorrect) {
      displayColor = Colors.red;
    } else if (state.status == AnswerStatus.correct) {
      displayColor = Colors.green;
    }

    return Container(
      decoration: kIsWeb
          ? BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            )
          : null,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: Column(
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => _showInfoDialog(context),
                    icon: Icon(
                      Icons.info_outline_rounded,
                      size: 32,
                      color: Theme.of(context)
                          .extension<GameThemeColors>()!
                          .textMainColor,
                    ),
                    tooltip: AppLocalizations.of(context)!.multiplicationInfo,
                  ),
                  const MultiplicandSelector(),
                ],
              ),
            ),
            const Spacer(),
            Center(
              child: Text(
                state.displayOutput,
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(color: displayColor),
              ),
            ),
            const Spacer(),
            Keypad(
              onNumberTap: (number) => context
                  .read<MultiplicationExerciseBloc>()
                  .add(ButtonPressed(number)),
              onBackspaceTap: () => context
                  .read<MultiplicationExerciseBloc>()
                  .add(BackspacePressed()),
              onRefreshTap: () => context
                  .read<MultiplicationExerciseBloc>()
                  .add(ExerciseRequested()),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    final gameColors = Theme.of(context).extension<GameThemeColors>()!;
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          l10n.multiplicationInfo,
          style: TextStyle(color: gameColors.textMainColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.multiplicationDescription,
              style: TextStyle(color: gameColors.textMainColor, fontSize: 16),
            ),
            const SizedBox(height: 24),
            RichText(
              text: TextSpan(
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: l10n.multiplicand,
                    style: TextStyle(color: gameColors.numberBtnColor2),
                  ),
                  TextSpan(
                    text: ' × ',
                    style: TextStyle(color: gameColors.textMainColor),
                  ),
                  TextSpan(
                    text: l10n.multiplier,
                    style: TextStyle(color: gameColors.numberBtnColor1),
                  ),
                  TextSpan(
                    text: ' = ',
                    style: TextStyle(color: gameColors.textMainColor),
                  ),
                  TextSpan(
                    text: l10n.product,
                    style: TextStyle(color: gameColors.numberBtnColor3),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: '7',
                    style: TextStyle(color: gameColors.numberBtnColor2),
                  ),
                  TextSpan(
                    text: ' × ',
                    style: TextStyle(color: gameColors.textMainColor),
                  ),
                  TextSpan(
                    text: '8',
                    style: TextStyle(color: gameColors.numberBtnColor1),
                  ),
                  TextSpan(
                    text: ' = ',
                    style: TextStyle(color: gameColors.textMainColor),
                  ),
                  TextSpan(
                    text: '56',
                    style: TextStyle(color: gameColors.numberBtnColor3),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              l10n.ok,
              style: TextStyle(
                  color: gameColors.textMainColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
