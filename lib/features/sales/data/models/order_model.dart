import 'package:gss_manager_app/core/models/branch_modal.dart';
import 'package:gss_manager_app/core/models/user_model.dart';
import 'package:gss_manager_app/features/sales/data/models/customer_model.dart';

class OrderModel {
  final int id;
  final String orderCode;
  final String orderDate;
  final int top;
  final String? dueDate;
  final String? receivedDate;
  final int totalAmount;
  final int? paidAmount;
  final int remainingAmount;
  final String status;
  final UserModel user;
  final CustomerModel customer;
  final BranchModel branch;
  final String createdAt;

  OrderModel({
    required this.id,
    required this.orderCode,
    required this.orderDate,
    required this.top,
    this.dueDate,
    this.receivedDate,
    required this.totalAmount,
    this.paidAmount,
    required this.remainingAmount,
    required this.status,
    required this.user,
    required this.customer,
    required this.branch,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      orderCode: json['order_code'],
      orderDate: json['order_date'],
      top: json['top'],
      dueDate: json['due_date'],
      receivedDate: json['received_date'],
      totalAmount: json['total_amount'],
      paidAmount: json['paid_amount'],
      remainingAmount: json['remaining_amount'],
      status: json['status'],
      user: UserModel.fromJson(json['user']),
      customer: CustomerModel.fromJson(json['customer']),
      branch: BranchModel.fromJson(json['branch']),
      createdAt: json['created_at'],
    );
  }
}
