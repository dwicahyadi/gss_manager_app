part of 'stock_attention_bloc.dart';

sealed class StockAttentionEvent extends Equatable {
  const StockAttentionEvent();

  @override
  List<Object> get props => [];
}

class LoadStockAttentionData extends StockAttentionEvent {}
