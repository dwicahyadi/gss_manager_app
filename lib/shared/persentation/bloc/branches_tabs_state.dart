import 'package:equatable/equatable.dart';
import 'package:gss_manager_app/core/models/branch_modal.dart';

abstract class BranchesState extends Equatable {
  const BranchesState();

  @override
  List<Object> get props => [];
}

class BranchesInitial extends BranchesState {}

class BranchesLoading extends BranchesState {}

class BranchesLoaded extends BranchesState {
  final List<BranchModel> branches;

  const BranchesLoaded(this.branches);

  @override
  List<Object> get props => [branches];
}

class BranchSelectedState extends BranchesState {
  final BranchModel selectedBranch;

  const BranchSelectedState(this.selectedBranch);

  @override
  List<Object> get props => [selectedBranch];
}

class BranchesError extends BranchesState {
  final String message;

  const BranchesError(this.message);

  @override
  List<Object> get props => [message];
}
