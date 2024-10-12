part of 'top_salesman_bloc.dart';

sealed class TopSalesmanState extends Equatable {
  const TopSalesmanState();

  @override
  List<Object> get props => [];
}

final class TopSalesmanInitial extends TopSalesmanState {}

final class TopSalesmanLoading extends TopSalesmanState {}

final class TopSalesmanLoaded extends TopSalesmanState {
  final List<SalesmanModel> salesmen;

  const TopSalesmanLoaded(this.salesmen);

  @override
  List<Object> get props => [salesmen];
}

final class TopSalesmanError extends TopSalesmanState {
  final String message;

  const TopSalesmanError(this.message);

  @override
  List<Object> get props => [message];
}

final class TopSalesmanEmpty extends TopSalesmanState {}

final class SalesmanDetailLoaded extends TopSalesmanState {
  final SalesmanModel salesman;

  const SalesmanDetailLoaded(this.salesman);

  @override
  List<Object> get props => [salesman];
}
