import 'package:flutter/material.dart';
import 'package:flutter_application_with_hive/db/category/category_db.dart';
import 'package:flutter_application_with_hive/model/cat_model.dart';

ValueNotifier<CategoryType> selectedCategory = ValueNotifier(CategoryType.income);

Future<void> showCategoryAddPop(BuildContext context) async {
  final _nameEditingController=TextEditingController();
  showDialog(
    context: context,
    builder: (ctx) {
      return SimpleDialog(
        title: const Text('Add Category'),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _nameEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Category',
                hintText: "Category Name",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ValueListenableBuilder<CategoryType>(
              valueListenable: selectedCategory,
              builder: (BuildContext context, CategoryType value, Widget? child) {
                return Row(
                  children: [
                    RadioButton(
                      title: 'Income',
                      type: CategoryType.income,
                      groupValue: value,
                      onChanged: (CategoryType? newValue) {
                        if (newValue != null) {
                          selectedCategory.value = newValue;
                        }
                      },
                    ),
                    RadioButton(
                      title: 'Expense',
                      type: CategoryType.expense,
                      groupValue: value,
                      onChanged: (CategoryType? newValue) {
                        if (newValue != null) {
                          selectedCategory.value = newValue;
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                final _name=_nameEditingController.text.trim();
                if(_name.isEmpty)
                {

                }
                final _type=selectedCategory.value;
                final _category=CategoryModel(id: DateTime.now().millisecondsSinceEpoch.toString(), name: _name, type: _type);
                CategoryDB.instance.insertCategory(_category);
                print(_category);
                Navigator.of(ctx).pop();


              },
              child: Text("Add"),
            ),
          ),
        ],
      );
    },
  );
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;
  final CategoryType groupValue;
  final ValueChanged<CategoryType?> onChanged;

  const RadioButton({
    super.key,
    required this.title,
    required this.type,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<CategoryType>(
          value: type,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        Text(title),
      ],
    );
  }
}
