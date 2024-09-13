import 'package:flutter/material.dart';
import 'package:flutter_application_with_hive/screens/add_transaction/screen_add_transaction.dart';
import 'package:flutter_application_with_hive/screens/category/category_add_pop.dart';
import 'package:flutter_application_with_hive/screens/category/screen_category.dart';
import 'package:flutter_application_with_hive/screens/home/widgets/bottom_navgation.dart';
import 'package:flutter_application_with_hive/screens/transactions/screen_transaction.dart';

class ScreenHome extends StatelessWidget {
   ScreenHome({super.key});
static ValueNotifier<int>selectedIndexNotifier=ValueNotifier(0);
final _pages=[ScreenTransaction(),ScreenCategory()
             
             ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: Text("Money Manager",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold) ,),
      centerTitle: true,backgroundColor: Colors.purple[600],),
      bottomNavigationBar: MoneyMangerBottomNavigation(),
      body: SafeArea(child: ValueListenableBuilder(
        valueListenable:selectedIndexNotifier,
        builder: (BuildContext,int updatedIndex,_){
          return _pages[updatedIndex];

        },
      ),
      ),
      floatingActionButton:FloatingActionButton(onPressed: (){
        if(selectedIndexNotifier.value == 0)
        {
          Navigator.of(context).pushNamed(ScreenAddTransaction.routeName);
          // print("Add transactions");
          // final _sample=CategoryModel(id: DateTime.now().millisecondsSinceEpoch.toString(), name: "travel", type: CategoryType.expense);
          // CategoryDB().insertCategory(_sample);
          // print(_sample);
        }
        else{
          showCategoryAddPop(context);

        }
      },child:Icon(Icons.add,color: Colors.white,),
      backgroundColor: Colors.purple[600],
      ),
      
    );
  }
}