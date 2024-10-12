import 'package:gss_manager_app/core/models/branch_modal.dart';

class BranchStockModel {
  final BranchModel branch;
  final int totalStockValue;

  BranchStockModel({
    required this.branch,
    required this.totalStockValue,
  });

  factory BranchStockModel.fromJson(Map<String, dynamic> json) {
    return BranchStockModel(
      branch: BranchModel.fromJson(json['branch']),
      totalStockValue: json['total_stock_value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch': branch.toJson(),
      'total_stock_value': totalStockValue,
    };
  }
}
