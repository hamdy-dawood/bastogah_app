class Report {
  final String? id;
  final num orderNo;
  final num shippingPrice;
  final num appPrice;
  final num shippingProfit;
  final num totalProfit;
  final num driverDues;
  final num merchantDues;

  Report({
    required this.id,
    required this.orderNo,
    required this.shippingPrice,
    required this.appPrice,
    required this.shippingProfit,
    required this.totalProfit,
    required this.driverDues,
    required this.merchantDues,
  });
}

class Balance {
  final num total;
  final num inn;
  final num out;

  Balance({required this.total, required this.inn, required this.out});
}
