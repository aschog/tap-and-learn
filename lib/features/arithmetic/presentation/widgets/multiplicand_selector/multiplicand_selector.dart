import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplication_trainer/config/theme/app_colors.dart';
import 'package:multiplication_trainer/features/arithmetic/presentation/widgets/multiplicand_selector/cubit/multiplicand_config_cubit.dart';
import 'package:multiplication_trainer/l10n/app_localizations.dart';

class MultiplicandSelector extends StatefulWidget {
  const MultiplicandSelector({super.key});

  @override
  State<MultiplicandSelector> createState() => _MultiplicandSelectorState();
}

class _MultiplicandSelectorState extends State<MultiplicandSelector> {
  List<int> _tempSelectedMultiplicands = [];

  @override
  Widget build(BuildContext context) {
    final gameColors = Theme.of(context).extension<GameThemeColors>()!;
    final menuTextStyle = TextStyle(
      color: gameColors.textMainColor,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );

    return BlocBuilder<MultiplicandConfigCubit, MultiplicandConfigState>(
      builder: (context, state) {
        return MenuAnchor(
          style: const MenuStyle(
            padding: WidgetStatePropertyAll(EdgeInsets.all(12)),
          ),
          builder:
              (BuildContext context, MenuController controller, Widget? child) {
            return IconButton(
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  setState(() {
                    _tempSelectedMultiplicands =
                        List.from(state.selectedMultiplicands);
                  });
                  controller.open();
                }
              },
              icon: Icon(Icons.settings,
                  size: 32, color: gameColors.textMainColor),
              tooltip: AppLocalizations.of(context)!.selectMultiplicands,
            );
          },
          menuChildren: [
            ...List.generate(
              10,
              (int multiplicand) => MenuItemButton(
                key: ValueKey('multiplicand_$multiplicand'),
                closeOnActivate: false,
                style: ButtonStyle(
                  backgroundColor:
                      const WidgetStatePropertyAll(Colors.transparent),
                  foregroundColor:
                      WidgetStatePropertyAll(gameColors.textMainColor),
                ),
                onPressed: () {
                  setState(() {
                    if (_tempSelectedMultiplicands.contains(multiplicand)) {
                      _tempSelectedMultiplicands.remove(multiplicand);
                    } else {
                      _tempSelectedMultiplicands.add(multiplicand);
                    }
                  });
                },
                leadingIcon: _tempSelectedMultiplicands.contains(multiplicand)
                    ? Icon(
                        Icons.check_rounded,
                        color: gameColors.textMainColor,
                        size: 24,
                      )
                    : const SizedBox(
                        width: 24,
                        height: 24,
                      ),
                child: Text(multiplicand.toString(), style: menuTextStyle),
              ),
            ),
            Divider(
              color: gameColors.textMainColor!.withValues(),
              height: 24,
              thickness: 2,
            ),
            MenuItemButton(
              key: const ValueKey('apply_button'),
              style: ButtonStyle(
                backgroundColor:
                    WidgetStatePropertyAll(gameColors.numberBtnColor1),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              onPressed: () {
                if (_tempSelectedMultiplicands.isNotEmpty) {
                  context
                      .read<MultiplicandConfigCubit>()
                      .updateMultiplicands(_tempSelectedMultiplicands);
                }
              },
              child: Center(
                  child: Text(
                AppLocalizations.of(context)!.apply,
                style: menuTextStyle,
              )),
            ),
          ],
        );
      },
    );
  }
}
