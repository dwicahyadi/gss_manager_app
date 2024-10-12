import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gss_manager_app/config/api.dart';
import 'package:gss_manager_app/core/constants/shared_prefs_keys.dart';
import 'package:gss_manager_app/features/sales/data/models/order_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

part 'order_list_event.dart';
part 'order_list_state.dart';

class OrderListBloc extends Bloc<OrdersEvent, OrdersState> {
  OrderListBloc() : super(OrdersInitial()) {
    on<LoadOrdersData>(_onLoadOrdersData);
    on<LoadNextPage>(_onLoadNextPage);
  }

  Future<void> _onLoadOrdersData(
      LoadOrdersData event, Emitter<OrdersState> emit) async {
    emit(OrdersLoading());
    try {
      final token = await _getToken();

      final queryParams = {
        'branch_id': event.branchId.toString(),
        if (event.startDate != null) 'start_date': event.startDate.toString(),
        if (event.endDate != null) 'end_date': event.endDate.toString(),
        if (event.status != null) 'status': event.status,
        if (event.userId != null) 'user_id': event.userId.toString(),
        if (event.customerId != null)
          'customer_id': event.customerId.toString(),
      };

      final uri =
          Uri.parse(GisaApiConfig.orders).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final orders = (data['data'] as List)
            .map((order) => OrderModel.fromJson(order))
            .toList();
        final nextPageUrl = data['links']['next'];

        emit(OrdersLoaded(orders: orders, nextPageUrl: nextPageUrl));
      } else if (response.statusCode == 401) {
        emit(OrdersUnauthorized());
      } else {
        emit(const OrdersError('Failed to load data'));
      }
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  Future<void> _onLoadNextPage(
      LoadNextPage event, Emitter<OrdersState> emit) async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse(event.nextPageUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newOrders = (data['data'] as List)
            .map((order) => OrderModel.fromJson(order))
            .toList();
        final nextPageUrl = data['links']['next'];

        if (state is OrdersLoaded) {
          final currentState = state as OrdersLoaded;
          final allOrders = List<OrderModel>.from(currentState.orders)
            ..addAll(newOrders);

          emit(OrdersLoaded(orders: allOrders, nextPageUrl: nextPageUrl));
        }
      } else if (response.statusCode == 401) {
        emit(OrdersUnauthorized());
      } else {
        emit(const OrdersError('Failed to load data'));
      }
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPrefsKeys.token) ?? '';
  }
}
