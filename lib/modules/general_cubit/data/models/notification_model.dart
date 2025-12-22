class NotificationsModel {
  final String id;
  final String title;
  final String body;
  final bool seen;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  NotificationsModel({
    required this.id,
    required this.title,
    required this.body,
    required this.seen,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
      id: json["_id"],
      title: json["title"],
      body: json["body"],
      seen: json["seen"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      v: json["__v"],
    );
  }
}
