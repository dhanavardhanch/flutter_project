class StoreModel {
  final int id;
  final String name;
  final String area;
  final String color;
  final String lifeValue;
  final String repeatCount;
  final String storeImage;

  StoreModel({
    required this.id,
    required this.name,
    required this.area,
    required this.color,
    required this.lifeValue,
    required this.repeatCount,
    required this.storeImage,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'],
      name: json['name'],
      area: json['area'],
      color: json['color'] ?? '',
      lifeValue: json['lifeValue'] ?? '',
      repeatCount: json['repeat_count'] ?? '',
      storeImage: json['store_image'] ?? '',
    );
  }

  // ✅ ADD THIS METHOD
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'area': area,
      'color': color,
      'lifeValue': lifeValue,
      'repeat_count': repeatCount,
      'store_image': storeImage,
    };
  }
}
