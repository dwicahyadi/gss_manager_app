part of 'stock_branch_bloc.dart';

abstract class StockBranchEvent extends Equatable {
  const StockBranchEvent();

  @override
  List<Object> get props => [];
}

class LoadStockBranchData extends StockBranchEvent {
  final int branchId;
  const LoadStockBranchData(this.branchId);

  @override
  List<Object> get props => [branchId];
}

class LoadNextPage extends StockBranchEvent {
  final String nextPageUrl;
  const LoadNextPage(this.nextPageUrl);

  @override
  List<Object> get props => [nextPageUrl];
}
