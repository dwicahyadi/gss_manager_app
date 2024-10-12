import 'package:equatable/equatable.dart';

abstract class BranchesEvent extends Equatable {
  const BranchesEvent();

  @override
  List<Object> get props => [];
}

class LoadBranches extends BranchesEvent {}
