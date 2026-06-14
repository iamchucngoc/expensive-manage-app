class CategoryModel {
  final String id;
  final String userId; // BẮT BUỘC PHẢI CÓ ĐỂ BẢO MẬT
  final String name;
  final String icon;
  final String type;
  final String colorHex;

  CategoryModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.icon,
    required this.type,
    required this.colorHex,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "name": name,
      "icon": icon,
      "type": type,
      "colorHex": colorHex,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map["id"],
      userId: map["userId"] ?? "",
      name: map["name"],
      icon: map["icon"],
      type: map["type"] ?? "expense",
      colorHex: map["colorHex"] ?? "#000000",
    );
  }
}