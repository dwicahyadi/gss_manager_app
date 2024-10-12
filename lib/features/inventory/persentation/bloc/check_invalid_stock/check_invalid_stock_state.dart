part of 'check_invalid_stock_bloc.dart';

sealed class CheckInvalidStockState extends Equatable {
  const CheckInvalidStockState();
  
  @override
  List<Object> get props => [];
}

final class CheckInvalidStockInitial extends CheckInvalidStockState {}
