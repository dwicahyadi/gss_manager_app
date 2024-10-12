import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadDashboardData extends DashboardEvent {
  final int branchId;

  const LoadDashboardData(this.branchId);

  @override
  List<Object> get props => [branchId];
}
