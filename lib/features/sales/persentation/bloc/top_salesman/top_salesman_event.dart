part of 'top_salesman_bloc.dart';

sealed class TopSalesmanEvent extends Equatable {
  const TopSalesmanEvent();

  @override
  List<Object> get props => [];
}

final class LoadTopSalesman extends TopSalesmanEvent {
  final int branchId;
  final int? limit;

  const LoadTopSalesman(this.branchId, this.limit);

  @override
  List<Object> get props => [branchId];
}

final class LoadSalesmanDetail extends TopSalesmanEvent {
  final int salesmanId;

  const LoadSalesmanDetail(this.salesmanId);

  @override
  List<Object> get props => [salesmanId];
}
