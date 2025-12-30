class BeatModel {
  final String area;
  final int storeCount;

  BeatModel({
    required this.area,
    required this.storeCount,
  });

  factory BeatModel.fromJson(Map<String, dynamic> json) {
    return BeatModel(
      area: json['area'],
      storeCount: json['store_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'area': area,
      'store_count': storeCount,
    };
  }
}
