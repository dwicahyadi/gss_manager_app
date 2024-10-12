class ProductModel {
  final int id;
  final String code;
  final String? sku;
  final String name;
  final String? description;
  final String? image;
  final int? cost;
  final String? brand;
  final String? model;
  final int? hasStock;
  final int? qtyControl;
  final int? isActive;
  final Category? category;

  ProductModel({
    required this.id,
    required this.code,
    this.sku,
    required this.name,
    this.description,
    this.image,
    this.cost,
    this.brand,
    this.model,
    this.hasStock,
    this.qtyControl,
    this.isActive,
    this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      code: json['code'],
      sku: json['sku'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      cost: json['cost'],
      brand: json['brand'],
      model: json['model'],
      hasStock: json['has_stock'],
      qtyControl: json['qty_control'],
      isActive: json['is_active'],
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'sku': sku,
      'name': name,
      'description': description,
      'image': image,
      'cost': cost,
      'brand': brand,
      'model': model,
      'has_stock': hasStock,
      'qty_control': qtyControl,
      'is_active': isActive,
      'category': category?.toJson(),
    };
  }
}

class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
