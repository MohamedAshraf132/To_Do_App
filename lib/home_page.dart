import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/to_do_widget.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = TextEditingController();
  List items = [];
  @override
  void initState() {
    super.initState();
    loadTasks(); // تحميل المهام عند بدء التطبيق
  }

  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      setState(() {
        items = jsonDecode(tasksString);
      });
    }
  }

  Future<void> saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedTasks = jsonEncode(items);
    await prefs.setString('tasks', encodedTasks);
  }

  void checkboxchange(int index) {
    setState(() {
      items[index][1] = !items[index][1];
    });
    saveTasks();
  }

  void deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
    saveTasks();
  }

  void saveItem() {
    setState(() {
      items.add([controller.text, false]);
      controller.clear();
    });
    saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      appBar: AppBar(
        title: Text(
          'TO DO APP',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Dismissible(
            onDismissed: (direction) {
              deleteItem(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Task deleted')),
              );
            },
            key: UniqueKey(),
            child: ToDoWidget(
              name: items[index][0],
              completed: items[index][1],
              onChanged: (value) => checkboxchange(index),
            ),
          );
        },
        itemCount: items.length,
      ),
      floatingActionButton: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Add a new item',
                  filled: true,
                  fillColor: Colors.deepPurple.shade200,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepPurple,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepPurple,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: saveItem,
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
