import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lab1/elements/home/current_day.dart';

class HomeContainer extends StatelessWidget {
  const HomeContainer({super.key});
  @override
  Widget build(BuildContext context){
    final mediaQuery = MediaQuery.of(context);
    final minSize = min(mediaQuery.size.width, mediaQuery.size.height);

    final List<Widget> children = [];

    children.add(
      Text(
        style: Theme.of(context).textTheme.
        headlineMedium,
        textAlign: TextAlign.center,
        'Home Page',
      ),
    );

    children.add(
      const Text(
        'This is home page. Here will be '
            'all information about your budget,'
            ' your incomes and outcomes. '
            'Bellow is the pie-chart to see '
            'your every day progress:',
        style: TextStyle(fontSize: 16),
      ),
    );

    children.add(
      const Icon(
        Icons.circle_outlined,
        size: 230,
      ),
    );

    children.add(
      const CurrentDay(),
    );

    final mainColumn = Column(
      children: children
          .map(
            (e) => Padding(
          padding: const EdgeInsets.all(3),
          child: e,
        ),
      )
          .toList(),
    );

    final mainContainer = Container(
      padding: EdgeInsets.all(minSize * 0.03),
      width: mediaQuery.size.width,
      child: mainColumn,
    );

    return SingleChildScrollView(child: mainContainer);
  }
}
