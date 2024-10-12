import 'package:gss_manager_app/core/models/branch_modal.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? avatar;
  final List<BranchModel>? branches;
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatar,
    this.branches,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      avatar: json['avatar'],
      branches: json['branches'] != null
          ? (json['branches'] as List)
              .map((branch) => BranchModel.fromJson(branch))
              .toList()
          : null,
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'avatar': avatar,
      'branches': branches?.map((branch) => branch.toJson()).toList(),
      'token': token,
    };
  }
}
