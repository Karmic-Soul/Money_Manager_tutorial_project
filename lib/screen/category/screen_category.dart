import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/screen/category/expence_category_list.dart';
import 'package:money_manager/screen/category/income_category_list.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({super.key});

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    CategoryDB().refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey.shade700,
          tabs: const [
            Tab(
              text: 'INCOME',
              icon: Icon(Icons.money),
            ),
            Tab(
              text: 'EXPENSE',
              icon: Icon(Icons.money_off),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [IncomeCategoryList(), ExpenseCategoryList()],
          ),
        )
      ],
    );
  }
}
