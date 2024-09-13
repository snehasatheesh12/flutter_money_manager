import 'package:flutter/material.dart';
import 'package:flutter_application_with_hive/db/transactions/transaction_db.dart';
import 'package:flutter_application_with_hive/model/cat_model.dart';
import 'package:flutter_application_with_hive/model/tran_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    // Initial load of transactions
    TransactionDB.instance.refresh();

    return ValueListenableBuilder(
      valueListenable: TransactionDB.instance.TransactionListNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
        return ListView.separated(
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, index) {
            final _value = newList[index];
            return Slidable(
              key: Key(_value.id!),
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (ctx) {
                      TransactionDB.instance.deleteTransaction(_value.id!);
                    },
                    icon: Icons.delete,
                    label: "Delete",
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ],
              ),
              child: Card(
                color: Colors.white,
                elevation: 0,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 50,
                    backgroundColor: _value.type == CategoryType.income
                        ? Colors.green
                        : Colors.red,
                    child: Text(
                      parseDate(_value.date),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text("Rs ${_value.amount}"),
                  subtitle: Text("${_value.category.name}"),
                ),
              ),
            );
          },
          separatorBuilder: (ctx, index) {
            return const SizedBox(height: 10);
          },
          itemCount: newList.length,
        );
      },
    );
  }

  String parseDate(DateTime date) {
    return DateFormat.MMMd().format(date);
  }
}
