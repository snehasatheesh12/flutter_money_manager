import 'package:flutter/material.dart';
import 'package:flutter_application_with_hive/db/category/category_db.dart';
import 'package:flutter_application_with_hive/screens/category/expense_category_list.dart';
import 'package:flutter_application_with_hive/screens/category/income_category_list.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({super.key});

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory>with SingleTickerProviderStateMixin {
 late TabController _tabController;
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController=TabController(length: 2, vsync: this);
   CategoryDB().RefreshUI();

  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: [
          Tab(text:"INCOME"),
          Tab(text:"EXPENSE"),
        ]),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              IncomeCategoryList(),
            ExpenseCategoryList(),
            ]),
        )
      ],
    );
  }
}