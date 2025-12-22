class ErrorMessageModel {
  final String message;

  const ErrorMessageModel({required this.message});

  factory ErrorMessageModel.fromJson(Map<String, dynamic> json) =>
      ErrorMessageModel(message: json['message']);

  List<Object> get props => [message];
}
