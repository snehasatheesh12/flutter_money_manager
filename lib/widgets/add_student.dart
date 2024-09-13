import 'package:flutter/material.dart';
import 'package:flutter_application_with_hive/db/functions/db_functions.dart';
import 'package:flutter_application_with_hive/model/data_model.dart';

class AddStudentWidget extends StatelessWidget {
  AddStudentWidget({Key? key}) : super(key: key);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Name',
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _ageController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Age',
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: addStudentButtonClicked,
            icon: const Icon(Icons.add),
            label: const Text('Add student'),
          ),
        ],
      ),
    );
  }

  Future<void> addStudentButtonClicked() async {
    final _name = _nameController.text.trim();
    final _age = _ageController.text.trim();
    
    if (_name.isEmpty || _age.isEmpty) {
      return;
    }

    final _student = StudentModel(name: _name, Age: _age);
    await addStudent(_student);
    
    // Optionally clear text fields after adding student
    _nameController.clear();
    _ageController.clear();
  }
}
