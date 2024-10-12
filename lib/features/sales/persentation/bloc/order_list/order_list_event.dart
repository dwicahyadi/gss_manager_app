part of 'order_list_bloc.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrdersData extends OrdersEvent {
  final int branchId;
  final String? status;
  final int? userId;
  final int? customerId;
  final DateTime? startDate;
  final DateTime? endDate;

  const LoadOrdersData({
    required this.branchId,
    this.status,
    this.userId,
    this.customerId,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props =>
      [branchId, status, userId, customerId, startDate, endDate];
}

class LoadNextPage extends OrdersEvent {
  final String nextPageUrl;

  const LoadNextPage(this.nextPageUrl);

  @override
  List<Object?> get props => [nextPageUrl];
}
