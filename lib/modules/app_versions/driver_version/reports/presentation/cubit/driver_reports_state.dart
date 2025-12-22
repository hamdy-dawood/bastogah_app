part of 'driver_reports_cubit.dart';

abstract class DriverReportsStates {}

class DriverReportsInitial extends DriverReportsStates {}

class SummaryLoadingState extends DriverReportsStates {}

class ChartLoadingState extends DriverReportsStates {}

class ChartSuccessState extends DriverReportsStates {}

class ChartFailState extends DriverReportsStates {
  final String message;

  ChartFailState({required this.message});
}
