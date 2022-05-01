part of 'application_bloc.dart';

@immutable
abstract class ApplicationState {}

class ApplicationStarting extends ApplicationState {}

class ApplicationStarted extends ApplicationState {}
