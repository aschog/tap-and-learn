import 'package:flutter/material.dart';
import 'package:tap_and_learn/config/theme/app_colors.dart';
import 'package:tap_and_learn/l10n/app_localizations.dart';

class Keypad extends StatelessWidget {
  final Function(String) onNumberTap;
  final VoidCallback onBackspaceTap;
  final VoidCallback onRefreshTap;

  const Keypad({
    super.key,
    required this.onNumberTap,
    required this.onBackspaceTap,
    required this.onRefreshTap,
  });

  @override
  Widget build(BuildContext context) {
    final gameColors = Theme.of(context).extension<GameThemeColors>()!;

    final List<dynamic> keys = [
      '1', '2', '3',
      '4', '5', '6',
      '7', '8', '9',
      '*', '0', 'BACK' // Empty slot for alignment
    ];

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: keys.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        final key = keys[index];

        if (key == '') return const SizedBox.shrink();

        if (key == 'BACK') {
          return _buildButton(
            context: context,
            label: '⌫',
            color: gameColors.deleteBtnColor!,
            onTap: onBackspaceTap,
            icon: Icons.backspace_rounded,
          );
        }

        if (key == '*') {
          return _buildButton(
            context: context,
            label: AppLocalizations.of(context)!.refresh,
            color: gameColors.numberBtnColor1!,
            onTap: onRefreshTap,
            icon: Icons.refresh_rounded,
            iconColor: gameColors.textMainColor,
          );
        }

        return _buildButton(
          context: context,
          label: key,
          color: setColor(key, gameColors),
          onTap: () => onNumberTap(key),
        );
      },
    );
  }

  Color setColor(String key, GameThemeColors gameColors) {
    if (key == '4' || key == '5' || key == '6') {
      return gameColors.numberBtnColor2!;
    } else if (key == '7' || key == '8' || key == '9') {
      return gameColors.numberBtnColor3!;
    } else {
      return gameColors.numberBtnColor1!;
    }
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required Color color,
    required VoidCallback onTap,
    IconData? icon,
    Color? iconColor,
  }) {
    final gameColors = Theme.of(context).extension<GameThemeColors>()!;
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(24),
      elevation: 4,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Center(
          child: icon != null
              ? Icon(icon, color: iconColor ?? Colors.white, size: 32)
              : Text(
                  label,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: gameColors.textMainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 70),
                ),
        ),
      ),
    );
  }
}
