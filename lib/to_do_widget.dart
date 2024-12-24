import 'package:flutter/material.dart';

class ToDoWidget extends StatelessWidget {
  const ToDoWidget(
      {super.key,
      required this.name,
      required this.completed,
      required this.onChanged,
      this.deleteItem});
  final String name;
  final bool completed;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 0,
      ),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Checkbox(
                value: completed,
                onChanged: onChanged,
                checkColor: Colors.black,
                activeColor: Colors.white,
                side: BorderSide(
                  color: Colors.white,
                ),
              ),
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  decoration: completed
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: Colors.white,
                  decorationThickness: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
