import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gss_manager_app/config/api.dart';
import 'package:gss_manager_app/core/constants/shared_prefs_keys.dart';
import 'package:gss_manager_app/features/sales/persentation/bloc/dashboard/dashboard_event.dart';
import 'package:gss_manager_app/features/sales/persentation/bloc/dashboard/dashboard_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
  }

  Future<void> _onLoadDashboardData(
      LoadDashboardData event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      final token = await _getToken();
      //startdate is first day of the month
      final startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
      //enddate is last day of the month
      final endDate =
          DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

      final response = await http.get(
        Uri.parse(
            '${GisaApiConfig.salesSummary}?branch_id=${event.branchId}&start_date=$startDate&end_date=$endDate'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Use the dynamic token
        },
      );

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.contains('text/html') == true) {
          emit(const DashboardError('Received HTML response instead of JSON'));
          return;
        }

        final data = json.decode(response.body);
        print('OKOK ini response api ${data['data']}');

        emit(DashboardLoaded(
          totalSales: data['data']['total_sales'],
          totalOrders: data['data']['total_orders'],
          totalActiveCustomers: data['data']['total_customers_active'],
          totalProductsSold: data['data']['total_product_sold'],
          unpaidOrderValue: data['data']['total_unpaid_value'],
          overDueOrderValue: data['data']['total_overdue_value'],
        ));
      } else if (response.statusCode == 401) {
        emit(DashboardUnauthorized());
      } else {
        emit(DashboardError(response.body.toString()));
      }
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPrefsKeys.token) ?? '';
  }
}
