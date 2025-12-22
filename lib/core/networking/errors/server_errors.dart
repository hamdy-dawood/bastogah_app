import 'errors_models/error_message_model.dart';

class ServerError implements Exception {
  final ErrorMessageModel errorMessageModel;

  const ServerError(this.errorMessageModel);
}
