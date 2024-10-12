class AttentionModel {
  final int? invalidProductCost;
  final int? invalidProductQuantity;
  final int? lowStock;

  AttentionModel({
    this.invalidProductCost,
    this.invalidProductQuantity,
    this.lowStock,
  });

  factory AttentionModel.fromJson(Map<String, dynamic> json) {
    return AttentionModel(
      invalidProductCost: json['invalid_product_cost'],
      invalidProductQuantity: json['invalid_product_quantity'],
      lowStock: json['low_stock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invalid_product_cost': invalidProductCost,
      'invalid_product_quantity': invalidProductQuantity,
      'low_stock': lowStock,
    };
  }
}
