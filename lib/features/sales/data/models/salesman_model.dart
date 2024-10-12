import 'package:gss_manager_app/core/models/user_model.dart';

class SalesmanModel {
  final UserModel user;
  final int? totalSales;
  final int? totalOrders;
  final int? countActiveCustomer;
  final int? totalUnpaid;
  final int? totalOverdue;

  SalesmanModel({
    required this.user,
    this.totalSales,
    this.totalOrders,
    this.countActiveCustomer,
    this.totalUnpaid,
    this.totalOverdue,
  });

  factory SalesmanModel.fromJson(Map<String, dynamic> json) {
    return SalesmanModel(
      user: UserModel.fromJson(json['user']),
      totalSales: json['total_sales'],
      totalOrders: json['total_orders'],
      countActiveCustomer: json['count_active_customer'],
      totalUnpaid: json['total_unpaid'],
      totalOverdue: json['total_overdue'],
    );
  }
}
