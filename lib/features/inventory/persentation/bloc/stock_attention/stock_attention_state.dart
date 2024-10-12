part of 'stock_attention_bloc.dart';

sealed class StockAttentionState extends Equatable {
  const StockAttentionState();

  @override
  List<Object> get props => [];
}

class StockAttentionInitial extends StockAttentionState {}

class StockAttentionLoading extends StockAttentionState {}

class StockAttentionLoaded extends StockAttentionState {
  final AttentionModel attentionData;

  const StockAttentionLoaded(this.attentionData);

  @override
  List<Object> get props => [attentionData];
}

class StockAttentionError extends StockAttentionState {
  final String message;

  const StockAttentionError(this.message);

  @override
  List<Object> get props => [message];
}
