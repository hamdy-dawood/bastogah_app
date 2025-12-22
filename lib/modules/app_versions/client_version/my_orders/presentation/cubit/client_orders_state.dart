part of 'client_orders_cubit.dart';

abstract class ClientOrdersStates {}

class ClientOrdersInitial extends ClientOrdersStates {}

class LoadingState extends ClientOrdersStates {}

class OrdersSuccessState extends ClientOrdersStates {}

class OrdersFailState extends ClientOrdersStates {
  final String message;

  OrdersFailState({required this.message});
}
