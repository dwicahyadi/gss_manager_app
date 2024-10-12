import 'package:flutter/material.dart';

class ExpnesesPage extends StatelessWidget {
  const ExpnesesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [
              Icon(Icons.attach_money),
              SizedBox(width: 8),
              Text('Expenses Page'),
            ],
          ),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'SURABAYA'),
              Tab(text: 'BATAM'),
              Tab(text: 'JEMBER'),
            ],
            labelColor: Theme.of(context).primaryColor,
            indicatorColor: Theme.of(context).primaryColor,
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Content for Tab 1')),
            Center(child: Text('Content for Tab 2')),
            Center(child: Text('Content for Tab 3')),
          ],
        ),
      ),
    );
  }
}
