class ProductModel {
  final int id;
  final String name;
  final String description;
  final String image;
  final int costToCompany;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.costToCompany,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      costToCompany: json['cost_to_company'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'cost_to_company': costToCompany,
    };
  }
}
