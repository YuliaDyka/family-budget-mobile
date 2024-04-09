import 'package:flutter/material.dart';
import 'package:lab1/elements/home/calendar_element.dart';
import 'package:lab1/elements/home/calendar_stack_element.dart';

class CurrentDay extends StatelessWidget {
  const CurrentDay({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_sharp),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios_sharp),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CalendarElement(day: '7', weekDay: 'T'),
            CalendarStackElement(),
            CalendarElement(day: '9', weekDay: 'S'),
            CalendarElement(day: '10', weekDay: 'S'),
            CalendarElement(day: '11', weekDay: 'M'),
            CalendarElement(day: '12', weekDay: 'T'),
            CalendarElement(day: '13', weekDay: 'W'),
        ],
        ),
      ],
    );
  }
}
