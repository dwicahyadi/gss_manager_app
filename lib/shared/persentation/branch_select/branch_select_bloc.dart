import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gss_manager_app/core/constants/shared_prefs_keys.dart';
import 'package:gss_manager_app/core/models/branch_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'branch_select_event.dart';
part 'branch_select_state.dart';

class BranchSelectBloc extends Bloc<BranchSelectEvent, BranchSelectState> {
  BranchSelectBloc() : super(BranchSelectInitial()) {
    on<LoadBranches>(_onLoadBranches);
    on<BranchSelected>(_onBranchSelected);
  }

  Future<void> _onLoadBranches(
      LoadBranches event, Emitter<BranchSelectState> emit) async {
    emit(BranchesLoading());
    try {
      // Fetch branches from shared preferences
      final branches = await fetchBranches();
      final selectedBranch = await fetchSelectedBranch();
      emit(BranchesLoaded(branches, selectedBranch));
    } catch (e) {
      emit(BranchSelectError(e.toString()));
    }
  }

  Future<void> _onBranchSelected(
      BranchSelected event, Emitter<BranchSelectState> emit) async {
    emit(BranchesLoading());
    try {
      // Save the selected branch to shared preferences
      await saveSelectedBranch(event.selectedBranch);
      emit(BranchSelectedState(event.selectedBranch));
    } catch (e) {
      emit(BranchSelectError(e.toString()));
    }
  }

  Future<List<BranchModel>> fetchBranches() async {
    final prefs = await SharedPreferences.getInstance();
    final branchesString =
        prefs.getString(SharedPrefsKeys.userBranches) ?? '[]';
    final List<dynamic> branchesJson = json.decode(branchesString);
    final List<BranchModel> branches =
        branchesJson.map((branch) => BranchModel.fromJson(branch)).toList();
    branches.insert(0, BranchModel(id: 0, name: 'ALL'));
    return branches;
  }

  Future<BranchModel?> fetchSelectedBranch() async {
    final prefs = await SharedPreferences.getInstance();
    final branchString = prefs.getString(SharedPrefsKeys.selectedBranch);
    if (branchString != null) {
      return BranchModel.fromJson(json.decode(branchString));
    }
    return null;
  }

  Future<void> saveSelectedBranch(BranchModel branch) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        SharedPrefsKeys.selectedBranch, json.encode(branch.toJson()));
  }
}
