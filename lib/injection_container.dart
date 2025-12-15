import 'dart:math';

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tap_and_learn/config/arithmetic_config.dart';
import 'package:tap_and_learn/features/arithmetic/data/datasources/arithmetic_local_data_source.dart';
import 'package:tap_and_learn/features/arithmetic/data/repositories/arithmetic_repository_impl.dart';
import 'package:tap_and_learn/features/arithmetic/domain/logic/arithmetic_strategy.dart';
import 'package:tap_and_learn/features/arithmetic/domain/repositories/arithmetic_repository.dart';
import 'package:tap_and_learn/features/arithmetic/domain/usecases/generate_exercise.dart';
import 'package:tap_and_learn/features/arithmetic/domain/usecases/get_selected_operands1.dart';
import 'package:tap_and_learn/features/arithmetic/domain/usecases/save_selected_operands1.dart';
import 'package:tap_and_learn/features/arithmetic/presentation/bloc/exercise_bloc.dart';
import 'package:tap_and_learn/features/arithmetic/presentation/widgets/operand_selector/cubit/operand_config_cubit.dart';

final sl = GetIt.instance;

Future<void> init(ArithmeticConfig config) async {
  //! Config
  sl.registerLazySingleton<ArithmeticConfig>(() => config);
  sl.registerLazySingleton<ArithmeticStrategy>(() => config.strategy);

  //! Features - Arithmetic
  // Cubit
  sl.registerLazySingleton(() => OperandConfigCubit(
        getSelectedOperands1: sl(),
        saveSelectedOperands1: sl(),
      ));

  // Bloc
  sl.registerFactory(
    () => ExerciseBloc(
      generateExercise: sl(),
      operandConfigCubit: sl(),
      strategy: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GenerateExercise(sl()));
  sl.registerLazySingleton(() => GetSelectedOperands1(sl()));
  sl.registerLazySingleton(() => SaveSelectedOperands1(sl()));

  // Repository
  sl.registerLazySingleton<ArithmeticRepository>(
    () => ArithmeticRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ArithmeticLocalDataSource>(
    () => ArithmeticLocalDataSourceImpl(
      random: sl(),
      sharedPreferences: sl(),
      strategy: sl(),
    ),
  );

  //! External
  sl.registerLazySingleton(() => Random());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
