class CustomerModel {
  final int id;
  final String code;
  final String name;
  final String? address;
  final String? phone;

  CustomerModel({
    required this.id,
    required this.code,
    required this.name,
    this.address,
    this.phone,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
    );
  }
}
