// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Multiplication Trainer';

  @override
  String get selectOperands => 'Select Operands';

  @override
  String get apply => 'APPLY';

  @override
  String get refresh => 'REFRESH';

  @override
  String get multiplicationInfo => 'Multiplication Info';

  @override
  String get multiplicationDescription =>
      'Multiplication is repeated addition.';

  @override
  String get operand => 'Operand';

  @override
  String get multiplier => 'Multiplier';

  @override
  String get product => 'Product';

  @override
  String get ok => 'OK';
}
