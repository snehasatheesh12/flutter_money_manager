import 'package:hive_flutter/adapters.dart';
part 'data_model.g.dart';

@HiveType(typeId: 1)
class StudentModel{
  
  @HiveField(0)
   int? id;
  @HiveField(1)
  final String name;

@HiveField(2)
  final String Age;
  StudentModel({required this.name,required this.Age,this.id});
}
