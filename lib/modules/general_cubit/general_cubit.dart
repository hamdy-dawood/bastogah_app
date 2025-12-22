import 'package:bastoga/core/networking/dio.dart';
import 'package:bastoga/core/networking/endpoints.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'data/models/notification_model.dart';
import 'general_states.dart';

class GeneralCubit extends Cubit<GeneralStates> {
  GeneralCubit() : super(GeneralInitialState());

  final logger = Logger();

  final dioManager = DioManager();

  //============================ GET NOTIFICATIONS =================================//

  int notificationPage = 1;
  bool notificationHasReachedMax = false;
  List<NotificationsModel> notificationsList = [];

  Future<void> getNotificationsData() async {
    if (notificationHasReachedMax) return;

    notificationPage == 1
        ? emit(NotificationsLoadingState())
        : emit(NotificationsMoreLoadingState());

    try {
      final response = await dioManager.get(ApiConstants.notificationsUrl);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;

        final List<NotificationsModel> fetchedNotifications =
            data.map((item) => NotificationsModel.fromJson(item)).toList();

        if (fetchedNotifications.isEmpty && notificationPage == 1) {
          emit(NotificationsSuccessState());
          return;
        }

        if (fetchedNotifications.isEmpty || fetchedNotifications.length < 20) {
          notificationHasReachedMax = true;
          notificationsList.addAll(fetchedNotifications);
          emit(NotificationsSuccessState());
          return;
        }

        if (notificationPage == 1) {
          notificationsList = fetchedNotifications;
        } else {
          notificationsList.addAll(fetchedNotifications);
        }

        notificationPage++;

        emit(NotificationsSuccessState());
      } else {
        emit(NotificationsFailState(message: response.data["message"]));
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      emit(NotificationsFailState(message: 'An unknown error: $e'));
      logger.e(e);
    }
  }

  void handleDioException(DioException e) {
    if (e.type == DioExceptionType.cancel) {
      emit(NotificationsFailState(message: "Request was cancelled"));
    } else if (e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      emit(NotificationsFailState(message: "Connection timed out"));
    } else if (e.type == DioExceptionType.badResponse) {
      emit(NotificationsFailState(message: e.response?.data["message"]));
    } else {
      emit(NotificationsFailState(message: "Unknown error : $e"));
    }
  }

  clearNotificationsData() {
    notificationPage = 1;
    notificationHasReachedMax = false;
    notificationsList.clear();
  }
}
