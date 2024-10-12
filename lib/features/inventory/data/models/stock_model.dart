import 'package:gss_manager_app/core/models/product_model.dart';

class StockModel {
  final ProductModel product;
  final int quantity;
  final int? cost;
  final int total;

  StockModel({
    required this.product,
    required this.quantity,
    this.cost,
    required this.total,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'],
      cost: json['cost'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'cost': cost,
      'total': total,
    };
  }
}
