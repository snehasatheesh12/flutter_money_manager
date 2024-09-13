import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_with_hive/widgets/add_student.dart';

import 'package:flutter_application_with_hive/db/functions/db_functions.dart';


class ScreenHome1 extends StatelessWidget {
  const ScreenHome1({super.key});
 @override
  Widget build(BuildContext context) {
     getAllStudent();

    return Scaffold(
      body:SafeArea(child: Column(children: [
        AddStudentWidget(),
        const Expanded(child: ListStudentWidget())
      ],),)
    );
  }
}