import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/networking/errors/server_errors.dart';
import '../../domain/entities/orders.dart';
import '../../domain/repository/base_client_orders_repository.dart';

part 'client_orders_state.dart';

class ClientOrdersCubit extends Cubit<ClientOrdersStates> {
  final BaseClientOrdersRepository baseClientOrdersRepository;

  ClientOrdersCubit(this.baseClientOrdersRepository) : super(ClientOrdersInitial());

  List<Orders>? orders;

  Future getOrders({required int page, int? status}) async {
    if (page == 0) {
      emit(LoadingState());

      final Either<ServerError, List<Orders>> response = await baseClientOrdersRepository.getOrders(
        page: page,
        status: status,
      );

      response.fold((l) => emit(OrdersFailState(message: l.errorMessageModel.message)), (r) {
        orders = r;
        emit(OrdersSuccessState());
      });
    } else {
      final Either<ServerError, List<Orders>> response = await baseClientOrdersRepository.getOrders(
        page: page,
        status: status,
      );

      response.fold((l) => emit(OrdersFailState(message: l.errorMessageModel.message)), (r) {
        orders!.addAll(r);
        emit(OrdersSuccessState());
      });
    }
  }
}
