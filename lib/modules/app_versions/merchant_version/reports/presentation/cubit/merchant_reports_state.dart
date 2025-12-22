part of 'merchant_reports_cubit.dart';

abstract class MerchantReportsStates {}

class MerchantReportsInitial extends MerchantReportsStates {}

class SummaryLoadingState extends MerchantReportsStates {}

class ChartLoadingState extends MerchantReportsStates {}

class ChartSuccessState extends MerchantReportsStates {}

class ChartFailState extends MerchantReportsStates {
  final String message;

  ChartFailState({required this.message});
}
