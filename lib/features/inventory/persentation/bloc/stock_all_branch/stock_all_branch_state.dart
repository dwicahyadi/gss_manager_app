part of 'stock_all_branch_bloc.dart';

abstract class StockAllBranchState extends Equatable {
  const StockAllBranchState();

  @override
  List<Object> get props => [];
}

class StockAllBranchInitial extends StockAllBranchState {}

class StockAllBranchLoading extends StockAllBranchState {}

class StockAllBranchLoaded extends StockAllBranchState {
  final List<BranchStockModel> branchStocks;

  const StockAllBranchLoaded(this.branchStocks);

  @override
  List<Object> get props => [branchStocks];
}

class StockAllBranchError extends StockAllBranchState {
  final String message;

  const StockAllBranchError(this.message);

  @override
  List<Object> get props => [message];
}
