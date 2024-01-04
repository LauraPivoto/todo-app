import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:to_do_app/data/database.dart';
import 'package:to_do_app/util/dialog_box.dart';
import 'package:to_do_app/util/to_do.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _mybox = Hive.box('mybox');

  final _controller = TextEditingController();

  DatabaseData todo = DatabaseData();

  @override
  void initState() {
    if (_mybox.get('Todo') == null) {
      todo.createInitialData();
    } else {
      todo.loadData();
    }
    super.initState();
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      todo.todo[index][1] = !todo.todo[index][1];
    });
    todo.updateDataBase();
  }

  void saveNewTask() {
    todo.todo.add([_controller, false]);
    _controller.clear();
    Navigator.of(context).pop();
  }

  createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop,
          );
        });
  }

  void deleteTask(int index) {
    setState(() {
      todo.todo.remove(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('To Do List'),
      ),
      body: ListView.builder(
          itemCount: todo.todo.length,
          itemBuilder: (context, index) {
            return ToDoTile(
              taskName: todo.todo[index][0],
              taskComplete: todo.todo[index][1],
              onChanged: (value) => checkBoxChanged(value, index),
              deleteFunction: (context) => deleteTask,
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask(),
        child: Icon(Icons.add),
      ),
    );
  }
}
