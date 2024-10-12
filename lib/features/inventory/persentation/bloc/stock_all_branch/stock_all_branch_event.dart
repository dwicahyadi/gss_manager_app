part of 'stock_all_branch_bloc.dart';

abstract class StockAllBranchEvent extends Equatable {
  const StockAllBranchEvent();

  @override
  List<Object> get props => [];
}

class LoadStockAllBranchData extends StockAllBranchEvent {}
