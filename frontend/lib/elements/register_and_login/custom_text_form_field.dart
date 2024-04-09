import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget{
  final String defaultText;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    required this.defaultText,
    required this.controller,
    required this.validator,
    required this.obscureText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return
      TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: mediaQuery.size.width * 0.03,
          ),
          // background: Colors.white,
          border: const OutlineInputBorder(
            borderRadius:BorderRadius.all(Radius.circular(30)),
          ),
          hintText: defaultText,

        ),
        validator: validator,
      );
  }
}