import 'package:flutter/material.dart';
import 'package:tap_and_learn/app.dart';
import 'package:tap_and_learn/config/arithmetic_config.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(MultiplicationConfig());
  runApp(const TapAndLearnApp());
}
