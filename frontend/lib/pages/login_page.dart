import 'package:flutter/material.dart';
import 'package:lab1/elements/register_and_login/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Log in'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
          child: LoginContainer(),
        ),
    );
  }
}
