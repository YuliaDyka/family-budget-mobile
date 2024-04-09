import 'dart:math';

import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget{
  final String buttonText;
  final Widget destinationPage;

  const CustomTextButton({required this.buttonText,
    required this.destinationPage, super.key,});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final maxSize = max(mediaQuery.size.width, mediaQuery.size.height);
    return TextButton(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          TextStyle(
            fontSize: maxSize * 0.02,
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
