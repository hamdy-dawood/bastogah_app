import '../../domain/entities/config.dart';

class ConfigModel extends Config {
  ConfigModel({required super.maintenanceMode, required super.maintenanceMsg});

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
    maintenanceMode: json["maintenanceMode"] ?? false,
    maintenanceMsg: json["maintenanceMsg"] ?? "",
  );
}
