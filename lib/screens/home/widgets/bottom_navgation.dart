import 'package:flutter/material.dart';
import 'package:flutter_application_with_hive/screens/screen_home.dart';

class MoneyMangerBottomNavigation extends StatelessWidget {
  const MoneyMangerBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ScreenHome.selectedIndexNotifier,
      builder: (BuildContext ctx, int updatedIndex, Widget?_)
      {
       return BottomNavigationBar(
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.black,
        currentIndex:updatedIndex ,
        onTap: (NewIndex){
          ScreenHome.selectedIndexNotifier.value=NewIndex;
        },
        items:const [

        BottomNavigationBarItem(icon:Icon(Icons.home),label:"Transactions"),
        BottomNavigationBarItem(icon:Icon(Icons.category),label: "Category"),
      ]);
      },
    );
  }
}