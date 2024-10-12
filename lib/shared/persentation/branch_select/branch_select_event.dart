part of 'branch_select_bloc.dart';

abstract class BranchSelectEvent extends Equatable {
  const BranchSelectEvent();

  @override
  List<Object> get props => [];
}

class LoadBranches extends BranchSelectEvent {}

class BranchSelected extends BranchSelectEvent {
  final BranchModel selectedBranch;

  const BranchSelected(this.selectedBranch);

  @override
  List<Object> get props => [selectedBranch];
}
