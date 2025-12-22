import '../../domain/entities/report.dart';

class ReportModel extends Report {
  ReportModel({
    required super.id,
    required super.orderNo,
    required super.shippingPrice,
    required super.appPrice,
    required super.shippingProfit,
    required super.totalProfit,
    required super.driverDues,
    required super.merchantDues,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
    id: json['_id'],
    orderNo: json['ordersNo'],
    shippingPrice: json['shippingPrice'],
    appPrice: json['appPrice'],
    shippingProfit: json['shippingProfit'],
    totalProfit: json['totalProfit'],
    driverDues: json['driverDues'],
    merchantDues: json['merchantDues'],
  );
}

class BalanceModel extends Balance {
  BalanceModel({required super.total, required super.inn, required super.out});

  factory BalanceModel.fromJson(Map<String, dynamic> json) =>
      BalanceModel(total: json['total'] ?? 0, inn: json['in'] ?? 0, out: json['out'] ?? 0);
}
