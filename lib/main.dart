import 'package:flutter/material.dart';
import 'package:multiplication_trainer/features/arithmetic/presentation/pages/multiplication_trainer_screen.dart';
import 'package:multiplication_trainer/l10n/app_localizations.dart';
import 'injection_container.dart' as di;
import 'package:multiplication_trainer/config/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  await di.init();
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
      ],
      home: const MultiplicationTrainerScreen(),
    );
  }
}
