part of 'splash_cubit.dart';

abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashMaintenance extends SplashState {
  final String message;

  SplashMaintenance({required this.message});
}

class SplashSuccess extends SplashState {}

class SplashError extends SplashState {
  final String message;

  SplashError({required this.message});
}
