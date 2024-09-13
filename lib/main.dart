import 'package:flutter/material.dart';
import 'package:flutter_application_with_hive/model/cat_model.dart';
import 'package:flutter_application_with_hive/model/tran_model.dart';
import 'package:flutter_application_with_hive/screens/add_transaction/screen_add_transaction.dart';
import 'package:flutter_application_with_hive/screens/screen_home.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }

  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }
   if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }

  await Hive.openBox<CategoryModel>('categories');
  await Hive.openBox<TransactionModel>('transactions');


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ScreenHome(),
      routes: {
        ScreenAddTransaction.routeName:(ctx)=>ScreenAddTransaction(),
      },
    );
  }
}
