import '../../domain/entities/clients.dart';

class ClientsModel extends Clients {
  ClientsModel({required super.id, required super.username, required super.phone});

  factory ClientsModel.fromJson(Map<String, dynamic> json) =>
      ClientsModel(id: json['_id'], username: json['username'], phone: json['phone']);
}
