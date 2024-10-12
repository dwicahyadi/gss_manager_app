part of 'branch_select_bloc.dart';

abstract class BranchSelectState extends Equatable {
  const BranchSelectState();

  @override
  List<Object> get props => [];
}

class BranchSelectInitial extends BranchSelectState {}

class BranchesLoading extends BranchSelectState {}

class BranchesLoaded extends BranchSelectState {
  final List<BranchModel> branches;
  final BranchModel? selectedBranch;

  const BranchesLoaded(this.branches, this.selectedBranch);

  @override
  List<Object> get props => [branches];
}

class BranchSelectedState extends BranchSelectState {
  final BranchModel selectedBranch;

  const BranchSelectedState(this.selectedBranch);

  @override
  List<Object> get props => [selectedBranch];
}

class BranchSelectError extends BranchSelectState {
  final String message;

  const BranchSelectError(this.message);

  @override
  List<Object> get props => [message];
}
