class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final String type;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "icon": icon,
      "type": type,
    };
  }

  factory CategoryModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return CategoryModel(
      id: map["id"],
      name: map["name"],
      icon: map["icon"],
      type: map["type"] ?? "expense",
    );
  }
}