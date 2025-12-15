// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Einmaleins Trainer';

  @override
  String get selectOperands => 'Zahlen auswählen';

  @override
  String get apply => 'ANWENDEN';

  @override
  String get refresh => 'NEU LADEN';

  @override
  String get multiplicationInfo => 'Multiplikations Info';

  @override
  String get multiplicationDescription =>
      'Multiplikation ist wiederholte Addition.';

  @override
  String get operand => 'Operand';

  @override
  String get multiplier => 'Multiplikator';

  @override
  String get product => 'Produkt';

  @override
  String get ok => 'OK';

  @override
  String get multiplicand => 'Multiplikand';

  @override
  String get selectMultiplicands => 'Multiplikanden auswählen';

  @override
  String get additionAppTitle => 'Additions Trainer';

  @override
  String get additionInfo => 'Additions Info';

  @override
  String get additionDescription =>
      'Addition ist das Zusammenzählen von zwei oder mehr Zahlen.';

  @override
  String get summand => 'Summand';

  @override
  String get sum => 'Summe';
}
