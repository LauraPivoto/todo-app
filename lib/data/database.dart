import 'package:hive/hive.dart';

class DatabaseData {
  List todo = [];

  final _myBox = Hive.box('mybox');

  void createInitialData() {
    todo = [
      ["Do Exercise", false],
    ];
  }

  // load the data from database
  void loadData() {
    todo = _myBox.get("TODOLIST");
  }

  // update the database
  void updateDataBase() {
    _myBox.put("TODOLIST", todo);
  }
}
