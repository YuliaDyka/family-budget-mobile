import 'package:flutter/material.dart';

class CalendarElement extends StatelessWidget{
  final String day;
  final String weekDay;

  const CalendarElement({required this.day, required this.weekDay,
    super.key, });
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.lightGreen[300],
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 13,
            ),
            child:  Column(
              children: [
                Text(day),
                Text(weekDay),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
