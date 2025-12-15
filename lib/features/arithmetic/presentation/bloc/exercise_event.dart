part of 'execise_bloc.dart';

abstract class ExerciseEvent extends Equatable {
  const ExerciseEvent();

  @override
  List<Object> get props => [];
}

class ExerciseRequested extends ExerciseEvent {}

class ButtonPressed extends ExerciseEvent {
  final String buttonText;

  const ButtonPressed(this.buttonText);

  @override
  List<Object> get props => [buttonText];
}

class BackspacePressed extends ExerciseEvent {}
