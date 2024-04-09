import 'dart:math';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget{
  final String buttonText;
  final Widget destinationPage;

  const CustomElevatedButton({required this.buttonText, required this.
  destinationPage, super.key,});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final maxSize = max(mediaQuery.size.width, mediaQuery.size.height);
    return ElevatedButton(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          TextStyle(
            fontSize: maxSize * 0.025,
          ),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(builder: ( BuildContext context) =>
          destinationPage,),
        );
      },
      child: Text(buttonText),
    );
  }
}
