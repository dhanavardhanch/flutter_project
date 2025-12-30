class TransactionModel {
  final int id;
  final int orderId;
  final int storeId;
  final String saleDate;
  final int saleQty;
  final int productId;
  final int sellerId;
  final double amount;
  final int refillCount;
  final String? noSaleReason;
  final int zoneId;
  final String? latitude;
  final String? longitude;
  final String createdAt;
  final String updatedAt;

  TransactionModel({
    required this.id,
    required this.orderId,
    required this.storeId,
    required this.saleDate,
    required this.saleQty,
    required this.productId,
    required this.sellerId,
    required this.amount,
    required this.refillCount,
    this.noSaleReason,
    required this.zoneId,
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  // ---------------- FROM JSON ----------------
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      orderId: json['order_id'],
      storeId: json['store_id'],
      saleDate: json['sale_date'] ?? '',
      saleQty: json['sale_qty'] ?? 0,
      productId: json['product_id'] ?? 0,
      sellerId: json['seller_id'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      refillCount: json['refill_count'] ?? 0,
      noSaleReason: json['nosale_reason'],
      zoneId: json['zone_id'] ?? 0,
      latitude: json['latitude'],
      longitude: json['longitude'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  // ---------------- TO JSON (OFFLINE SAVE) ----------------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'store_id': storeId,
      'sale_date': saleDate,
      'sale_qty': saleQty,
      'product_id': productId,
      'seller_id': sellerId,
      'amount': amount,
      'refill_count': refillCount,
      'nosale_reason': noSaleReason,
      'zone_id': zoneId,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
