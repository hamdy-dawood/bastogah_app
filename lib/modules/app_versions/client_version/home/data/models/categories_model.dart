import '../../domain/entities/categories.dart';

class CategoriesModel extends Categories {
  CategoriesModel({
    required super.id,
    required super.image,
    required super.coverImage,
    required super.name,
    required super.deleted,
    required super.createdAt,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) => CategoriesModel(
    id: json['_id'],
    image: json['image'] ?? "",
    coverImage: json['coverImage'] ?? "",
    name: json['name'],
    deleted: json['deleted'] ?? false,
    createdAt: json['createdAt'] ?? "",
  );
}

//{
//         "_id": "667bcb4edea0d54baab15694",
//         "image": "1719388998285-81130-Screenshot 2024-06-22 161304.png",
//         "coverImage": "1719393045689-82662-Screenshot 2024-06-25 160905.png",
//         "name": "asdasdasdasdasdasdasd",
//         "deleted": false,
//         "createdAt": "2024-06-26T08:03:26.528Z",
//         "updatedAt": "2024-06-26T09:10:48.277Z",
//         "__v": 0
//     },
