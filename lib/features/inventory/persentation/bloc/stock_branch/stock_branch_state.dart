part of 'stock_branch_bloc.dart';

abstract class StockBranchState extends Equatable {
  const StockBranchState();

  @override
  List<Object> get props => [];
}

class StockBranchInitial extends StockBranchState {}

class StockBranchLoading extends StockBranchState {}

class StockBranchLoaded extends StockBranchState {
  final List<StockModel> stocks;
  final String? nextPageUrl;

  const StockBranchLoaded({required this.stocks, this.nextPageUrl});

  @override
  List<Object> get props => [stocks, nextPageUrl ?? ''];
}

class StockBranchError extends StockBranchState {
  final String message;

  const StockBranchError(this.message);

  @override
  List<Object> get props => [message];
}
