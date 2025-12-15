import 'package:tap_and_learn/features/arithmetic/domain/logic/arithmetic_strategy.dart';
import 'package:tap_and_learn/l10n/app_localizations.dart';

abstract class ArithmeticConfig {
  ArithmeticStrategy get strategy;
  String getAppTitle(AppLocalizations l10n);
  String getInfoTitle(AppLocalizations l10n);
  String getInfoDescription(AppLocalizations l10n);
  String getOperand1Label(AppLocalizations l10n);
  String getOperand2Label(AppLocalizations l10n);
  String getResultLabel(AppLocalizations l10n);
  
  // Example values for the info dialog
  String get exampleOperand1;
  String get exampleOperand2;
  String get exampleResult;
}

class MultiplicationConfig implements ArithmeticConfig {
  @override
  ArithmeticStrategy get strategy => MultiplicationStrategy();

  @override
  String getAppTitle(AppLocalizations l10n) => l10n.appTitle; // Or specific key

  @override
  String getInfoTitle(AppLocalizations l10n) => l10n.multiplicationInfo;

  @override
  String getInfoDescription(AppLocalizations l10n) => l10n.multiplicationDescription;

  @override
  String getOperand1Label(AppLocalizations l10n) => l10n.multiplicand;

  @override
  String getOperand2Label(AppLocalizations l10n) => l10n.multiplier;

  @override
  String getResultLabel(AppLocalizations l10n) => l10n.product;

  @override
  String get exampleOperand1 => '7';
  @override
  String get exampleOperand2 => '8';
  @override
  String get exampleResult => '56';
}

class AdditionConfig implements ArithmeticConfig {
  @override
  ArithmeticStrategy get strategy => AdditionStrategy();

  @override
  String getAppTitle(AppLocalizations l10n) => l10n.additionAppTitle;

  @override
  String getInfoTitle(AppLocalizations l10n) => l10n.additionInfo;

  @override
  String getInfoDescription(AppLocalizations l10n) => l10n.additionDescription;

  @override
  String getOperand1Label(AppLocalizations l10n) => l10n.summand;

  @override
  String getOperand2Label(AppLocalizations l10n) => l10n.summand;

  @override
  String getResultLabel(AppLocalizations l10n) => l10n.sum;

  @override
  String get exampleOperand1 => '7';
  @override
  String get exampleOperand2 => '8';
  @override
  String get exampleResult => '15';
}
