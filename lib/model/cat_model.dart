import 'package:hive/hive.dart';
part 'cat_model.g.dart';

@HiveType(typeId: 2)
enum CategoryType{
    @HiveField(0)
    income,
    @HiveField(1)
    expense,
}


@HiveType(typeId: 1)
class CategoryModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final CategoryType type;

  @HiveField(3)
  final bool isDeleted;


  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    this.isDeleted = false,
  });

  @override
  String toString() {
    // TODO: implement toString
    return '{$name $type}';
  }
}
