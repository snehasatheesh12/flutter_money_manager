import 'package:flutter/material.dart';
import 'package:flutter_application_with_hive/db/category/category_db.dart';
import 'package:flutter_application_with_hive/db/transactions/transaction_db.dart';
import 'package:flutter_application_with_hive/model/cat_model.dart';
import 'package:flutter_application_with_hive/model/tran_model.dart';
import 'package:flutter_application_with_hive/screens/category/category_add_pop.dart';
import 'package:hive_flutter/adapters.dart';

class ScreenAddTransaction extends StatefulWidget {
  static const routeName = 'add_transaction';

  const ScreenAddTransaction({Key? key}) : super(key: key);

  @override
  _ScreenAddTransactionState createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;
  final _purposeEditingContoller = TextEditingController();
  final _amountEditingContoller = TextEditingController();
  final ValueNotifier<List<TransactionModel>> _transactionsNotifier =
      ValueNotifier<List<TransactionModel>>([]); // Added ValueNotifier

  @override
  void initState() {
    super.initState();
    _selectedCategoryType = CategoryType.income;
    // Ensure the category lists are loaded
    CategoryDB.instance.RefreshUI();
    _loadTransactions(); // Load transactions initially
  }

  Future<void> _loadTransactions() async {
    final transactions = await TransactionDB.instance.getAllTransactions();
    _transactionsNotifier.value = transactions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Money Manager",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple[600],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _purposeEditingContoller,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Purpose",
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _amountEditingContoller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Amount",
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now().subtract(Duration(days: 30)),
                    lastDate: DateTime.now(),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _selectedDate = selectedDate;
                    });
                  }
                },
                icon: Icon(Icons.calendar_today_outlined),
                label: Text(
                  _selectedDate == null
                      ? 'Select Date'
                      : _selectedDate.toString(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.income,
                        groupValue: _selectedCategoryType,
                        onChanged: (CategoryType? newValue) {
                          setState(() {
                            _selectedCategoryType = newValue;
                            _selectedCategoryModel =
                                null; // Reset category selection
                          });
                        },
                      ),
                      Text("Income"),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.expense,
                        groupValue: _selectedCategoryType,
                        onChanged: (CategoryType? newValue) {
                          setState(() {
                            _selectedCategoryType = newValue;
                            _selectedCategoryModel =
                                null; // Reset category selection
                          });
                        },
                      ),
                      Text("Expense"),
                    ],
                  ),
                ],
              ),
              ValueListenableBuilder(
                valueListenable: _selectedCategoryType == CategoryType.income
                    ? CategoryDB.instance.incomeCategoryList
                    : CategoryDB.instance.expenseCategoryList,
                builder: (context, List<CategoryModel> categoryList, _) {
                  return Center(
                    child: DropdownButton<CategoryModel>(
                      hint: Text("Select Category"),
                      value: _selectedCategoryModel,
                      items: categoryList.map((category) {
                        return DropdownMenuItem<CategoryModel>(
                          value: category,
                          child: Text(category.name),
                          onTap: () {
                            _selectedCategoryModel = category;
                          },
                        );
                      }).toList(),
                      onChanged: (CategoryModel? newValue) {
                        setState(() {
                          _selectedCategoryModel = newValue;
                        });
                      },
                    ),
                  );
                },
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    addTransaction();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.purple),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.white),
                  ),
                  child: Text("SUBMIT"),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ValueListenableBuilder<List<TransactionModel>>(
                  valueListenable: _transactionsNotifier,
                  builder: (context, transactions, _) {
                    return ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return ListTile(
                          title: Text(transaction.purpose),
                          subtitle: Text(
                              '${transaction.amount.toString()} - ${transaction.date.toString()}'),
                          trailing: Text(transaction.type == CategoryType.income
                              ? 'Income'
                              : 'Expense'),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addTransaction() async {
    final _purposeText = _purposeEditingContoller.text;
    final _amountText = _amountEditingContoller.text;
    if (_purposeText.isEmpty ||
        _amountText.isEmpty ||
        _selectedDate == null ||
        _selectedCategoryModel == null) {
      return;
    }
    final _parsedAmount = double.tryParse(_amountText);
    if (_parsedAmount == null) {
      return;
    }

    final _transaction = TransactionModel(
      purpose: _purposeText,
      amount: _parsedAmount,
      date: _selectedDate!,
      type: _selectedCategoryType!,
      category: _selectedCategoryModel!,
    );

    await TransactionDB.instance.addTransaction(_transaction);
    // _loadTransactions(); // Reload transactions after adding new transaction
    Navigator.of(context).pop();
    

    _purposeEditingContoller.clear();
    _amountEditingContoller.clear();
    setState(() {
      _selectedDate = null;
      _selectedCategoryModel = null;
    });
  }
}
