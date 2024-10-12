class BranchModel {
  final int id;
  final String name;
  final String? address;
  final String? phone;

  BranchModel({
    required this.id,
    required this.name,
    this.address,
    this.phone,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
    };
  }
}
