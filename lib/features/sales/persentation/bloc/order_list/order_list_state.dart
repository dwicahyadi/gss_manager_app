part of 'order_list_bloc.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<OrderModel> orders;
  final String? nextPageUrl;

  const OrdersLoaded({required this.orders, this.nextPageUrl});

  @override
  List<Object> get props => [orders, nextPageUrl ?? ''];
}

class OrdersError extends OrdersState {
  final String message;

  const OrdersError(this.message);

  @override
  List<Object> get props => [message];
}

class OrdersUnauthorized extends OrdersState {}

class OrdersEmpty extends OrdersState {}
