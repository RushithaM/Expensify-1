import 'package:expensetracker/models/transaction_model.dart';
import 'package:expensetracker/screens/category/all_categories.dart';
import 'package:expensetracker/screens/category/categoryAnalysis.dart';
import 'package:expensetracker/screens/transactions/add_transaction.dart';
import 'package:expensetracker/screens/transactions/history.dart';
import 'package:expensetracker/screens/home/home.dart';
import 'package:expensetracker/styles/styles.dart';
import 'package:flutter/material.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    AllCategories(),
    AddTransactionPage(
        transaction: Transaction(
            id: '',
            categoryId: '',
            amount: 0,
            date: DateTime.now(),
            description: '',
            type: '',
            userId: ''),
        i: 0,
        j: 0,
        isEdit: false),
    CategoryAnalysisPage(),
    HistoryPage(),
  ];

  void _onItemTapped(int index) {
    if (mounted)
      setState(() {
        _selectedIndex = index;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: lightAppColor,
            selectedItemColor: appColor,
            unselectedItemColor: Colors.black,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home, size: 30), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category_outlined, size: 30),
                  label: 'Category'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add, size: 30), label: 'Add'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.analytics_outlined, size: 30),
                  label: 'Analysis'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history, size: 30), label: 'History'),
            ]));
  }
}
