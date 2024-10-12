import 'package:flutter/material.dart';
import 'package:gss_manager_app/core/models/branch_modal.dart';

class BranchesTabBar extends StatefulWidget implements PreferredSizeWidget {
  final List<BranchModel> branches;

  const BranchesTabBar({super.key, required this.branches});

  @override
  _BranchesTabBarState createState() => _BranchesTabBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _BranchesTabBarState extends State<BranchesTabBar> {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: widget.branches.map((branch) {
        final branchName = branch.name;
        return Tab(text: branchName);
      }).toList(),
      labelColor: Theme.of(context).primaryColor,
      indicatorColor: Theme.of(context).primaryColor,
      isScrollable: true,
    );
  }
}
