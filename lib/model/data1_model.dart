import 'package:hive/hive.dart';

part 'data1_model.g.dart';

@HiveType(typeId: 0)
class CategoryModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final bool isDeleted;

  CategoryModel({
    required this.id,
    required this.name,
    this.isDeleted = false,
  });
}
