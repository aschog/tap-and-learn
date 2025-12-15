import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tap_and_learn/config/arithmetic_config.dart';
import 'package:tap_and_learn/config/theme/app_theme.dart';
import 'package:tap_and_learn/features/arithmetic/presentation/pages/arithmetic_trainer_screen.dart';
import 'package:tap_and_learn/injection_container.dart';
import 'package:tap_and_learn/l10n/app_localizations.dart';

class TapAndLearnApp extends StatelessWidget {
  const TapAndLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => sl<ArithmeticConfig>().getAppTitle(AppLocalizations.of(context)!),
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
      home: const ArithmeticTrainerScreen(),
    );
  }
}
