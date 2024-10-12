import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'check_invalid_stock_event.dart';
part 'check_invalid_stock_state.dart';

class CheckInvalidStockBloc extends Bloc<CheckInvalidStockEvent, CheckInvalidStockState> {
  CheckInvalidStockBloc() : super(CheckInvalidStockInitial()) {
    on<CheckInvalidStockEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
