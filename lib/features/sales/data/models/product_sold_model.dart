import 'package:gss_manager_app/core/models/product_model.dart';

class ProductSoldModel {
  final ProductModel product;
  final int amount;
  final int quantity;

  ProductSoldModel({
    required this.product,
    required this.amount,
    required this.quantity,
  });

  factory ProductSoldModel.fromJson(Map<String, dynamic> json) {
    return ProductSoldModel(
      product: ProductModel.fromJson(json['product']),
      amount: json['amount'],
      quantity: json['quantity'],
    );
  }
}
