import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gss_manager_app/features/inventory/persentation/screens/inventory_dashboard_screen.dart';
import 'package:gss_manager_app/features/sales/persentation/screens/sales_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final PageStorageBucket _bucket = PageStorageBucket();

  static final List<Widget> _widgetOptions = <Widget>[
    const SalesPage(key: PageStorageKey('SalesPage')),
    const InventoryDashboardScreen(
        key: PageStorageKey('InventoryDashboardScreen')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: _bucket,
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.shopping_cart),
              label: 'Sales',
              activeIcon: Icon(CupertinoIcons.cart_fill)),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.cube_box),
              label: 'Stock',
              activeIcon: Icon(CupertinoIcons.cube_box_fill)),
        ],
        currentIndex: _selectedIndex,
        iconSize: 30,
        onTap: _onItemTapped,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        type: BottomNavigationBarType.fixed,
        elevation: 5,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
      ),
    );
  }
}
