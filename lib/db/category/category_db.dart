import 'package:flutter/foundation.dart';
import 'package:flutter_application_with_hive/model/cat_model.dart';
import 'package:hive_flutter/adapters.dart';

const CATEGORY_DB_NAME = 'category-database';

abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategory(CategoryModel value);
  Future<void>deleteCategory(String categoryId);
}

class CategoryDB implements CategoryDbFunctions {
  CategoryDB._internal();
  static final CategoryDB instance = CategoryDB._internal();
  factory CategoryDB() => instance;

  final ValueNotifier<List<CategoryModel>> incomeCategoryList = ValueNotifier([]);
  final ValueNotifier<List<CategoryModel>> expenseCategoryList = ValueNotifier([]);

  Box<CategoryModel>? _categoryDb;

  Future<void> _initDb() async {
    if (_categoryDb == null) {
      _categoryDb = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    }
  }

  @override
  Future<void> insertCategory(CategoryModel value) async {
    await _initDb();
    await _categoryDb?.put(value.id,value);
    await RefreshUI();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    await _initDb();
    return _categoryDb?.values.toList() ?? [];
  }

  Future<void> RefreshUI() async {
    final allCategory = await getCategories();
    incomeCategoryList.value.clear();
    expenseCategoryList.value.clear();

    for (var category in allCategory) {
      if (category.type == CategoryType.income) {
        incomeCategoryList.value.add(category);
      } else {
        expenseCategoryList.value.add(category);
      }
    }

    incomeCategoryList.notifyListeners();
    expenseCategoryList.notifyListeners();
  }
  
  @override
  Future<void> deleteCategory(String categoryId) async{
    final _categoryDb=await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    _categoryDb.delete(categoryId);
    RefreshUI();
    // TODO: implement deleteCategory
    throw UnimplementedError();
  }
}
