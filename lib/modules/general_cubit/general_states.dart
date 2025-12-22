abstract class GeneralStates {}

class GeneralInitialState extends GeneralStates {}

//========================= GET PENDING SANAD COUNT ===========================//

class GetPendingSanadCountLoadingState extends GeneralStates {}

class GetPendingSanadCountSuccessState extends GeneralStates {}

class GetPendingSanadCountFailState extends GeneralStates {
  final String message;

  GetPendingSanadCountFailState({required this.message});
}

//============================ GET NOTIFICATIONS =================================//

class NotificationsLoadingState extends GeneralStates {}

class NotificationsMoreLoadingState extends GeneralStates {}

class NotificationsFailState extends GeneralStates {
  final String message;

  NotificationsFailState({required this.message});
}

class NotificationsSuccessState extends GeneralStates {}
