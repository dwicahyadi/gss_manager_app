import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gss_manager_app/core/models/branch_modal.dart';
import 'package:gss_manager_app/shared/persentation/bloc/branches_tabs_event.dart';
import 'package:gss_manager_app/shared/persentation/bloc/branches_tabs_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:gss_manager_app/core/constants/shared_prefs_keys.dart';

class BranchesBloc extends Bloc<BranchesEvent, BranchesState> {
  BranchesBloc() : super(BranchesInitial()) {
    on<LoadBranches>(_onLoadBranches);
  }

  Future<void> _onLoadBranches(
      LoadBranches event, Emitter<BranchesState> emit) async {
    emit(BranchesLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final branchesString =
          prefs.getString(SharedPrefsKeys.userBranches) ?? '[]';
      final List<dynamic> branchesJson = json.decode(branchesString);
      final List<BranchModel> branches =
          branchesJson.map((branch) => BranchModel.fromJson(branch)).toList();

      branches.insert(0, BranchModel(id: 0, name: 'ALL'));

      emit(BranchesLoaded(branches));
    } catch (e) {
      emit(BranchesError(e.toString()));
    }
  }
}
