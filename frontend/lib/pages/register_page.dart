import 'package:flutter/material.dart';
import 'package:lab1/elements/register_and_login/register_controller.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen.shade300,
        title: const Text('Register new User'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: RegisterContainer(),
      ),
    );
  }
}
