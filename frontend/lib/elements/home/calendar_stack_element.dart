import 'package:flutter/material.dart';

class CalendarStackElement extends StatelessWidget{
  const CalendarStackElement({super.key});
  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.lightGreen,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
            child: const Column(
              children: [
                Text('8'),
                Text('F'),
                Icon(Icons.attach_money_rounded),
              ],
            ),
          ),
        ),
        Positioned(
          right: 1,
          top: 0,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.red,
              border: Border.all(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
