import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tap_and_learn/config/theme/app_colors.dart';
import 'package:tap_and_learn/features/arithmetic/presentation/widgets/operand_selector/cubit/operand_config_cubit.dart';
import 'package:tap_and_learn/l10n/app_localizations.dart';

class OperandSelector extends StatefulWidget {
  const OperandSelector({super.key});

  @override
  State<OperandSelector> createState() => _OperandSelectorState();
}

class _OperandSelectorState extends State<OperandSelector> {
  List<int> _tempSelectedOperands = [];

  @override
  Widget build(BuildContext context) {
    final gameColors = Theme.of(context).extension<GameThemeColors>()!;
    final menuTextStyle = TextStyle(
      color: gameColors.textMainColor,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );

    return BlocBuilder<OperandConfigCubit, OperandConfigState>(
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
                    _tempSelectedOperands = List.from(state.selectedOperands1);
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
              (int operand) => MenuItemButton(
                key: ValueKey('operand1_$operand'),
                closeOnActivate: false,
                style: ButtonStyle(
                  backgroundColor:
                      const WidgetStatePropertyAll(Colors.transparent),
                  foregroundColor:
                      WidgetStatePropertyAll(gameColors.textMainColor),
                ),
                onPressed: () {
                  setState(() {
                    if (_tempSelectedOperands.contains(operand)) {
                      _tempSelectedOperands.remove(operand);
                    } else {
                      _tempSelectedOperands.add(operand);
                    }
                  });
                },
                leadingIcon: _tempSelectedOperands.contains(operand)
                    ? Icon(
                        Icons.check_rounded,
                        color: gameColors.textMainColor,
                        size: 24,
                      )
                    : const SizedBox(
                        width: 24,
                        height: 24,
                      ),
                child: Text(operand.toString(), style: menuTextStyle),
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
                if (_tempSelectedOperands.isNotEmpty) {
                  context
                      .read<OperandConfigCubit>()
                      .updateOperands1(_tempSelectedOperands);
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
