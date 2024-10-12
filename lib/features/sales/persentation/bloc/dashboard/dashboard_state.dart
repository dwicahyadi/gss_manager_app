import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final int totalSales;
  final int totalOrders;
  final int totalActiveCustomers;
  final int totalProductsSold;
  final int unpaidOrderValue;
  final int overDueOrderValue;

  const DashboardLoaded({
    required this.totalSales,
    required this.totalOrders,
    required this.totalActiveCustomers,
    required this.totalProductsSold,
    required this.unpaidOrderValue,
    required this.overDueOrderValue,
  });

  @override
  List<Object> get props => [
        totalSales,
        totalOrders,
        totalActiveCustomers,
        totalProductsSold,
        unpaidOrderValue,
        overDueOrderValue,
      ];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object> get props => [message];
}

class DashboardUnauthorized extends DashboardState {}
