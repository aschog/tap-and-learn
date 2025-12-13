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
  String get selectMultiplicands => 'Zahlen auswählen';

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
  String get multiplicand => 'Multiplikand';

  @override
  String get multiplier => 'Multiplikator';

  @override
  String get product => 'Produkt';

  @override
  String get ok => 'OK';
}
