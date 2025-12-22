import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repository/base_auth_repository.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final BaseAuthRepository baseAuthRepository;

  SplashCubit(this.baseAuthRepository) : super(SplashInitial());

  Future<void> getConfig() async {
    emit(SplashLoading());
    final result = await baseAuthRepository.getConfig();

    result.fold((l) => emit(SplashError(message: l.errorMessageModel.message)), (r) {
      if (r.maintenanceMode) {
        emit(SplashMaintenance(message: r.maintenanceMsg));
      } else {
        emit(SplashSuccess());
      }
    });
  }
}
