import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lab1/elements/register_and_login/custom_elevated_button.dart';
import 'package:lab1/elements/register_and_login/custom_text_button.dart';
import 'package:lab1/elements/register_and_login/custom_text_form_field.dart';

// import 'package:lab1/pages/home_page.dart';
import 'package:lab1/pages/login_page.dart';

import '../../pages/management/user_bloc.dart';
import '../../pages/management/user_event.dart';
import '../../pages/management/user_state.dart';
import '../../service/logic_service.dart';

// import 'custom_text_field.dart';

// import 'custom_text_field.dart';

class RegisterContainer extends StatefulWidget {
  const RegisterContainer({super.key});

  @override
  State<RegisterContainer> createState() => _RegisterContainer();
}

class _RegisterContainer extends State<RegisterContainer> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final LogicService _service = MyService();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _attemptRegister() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (mounted) {
      context.read<UserBloc>().add(SignUpRequested(
          _usernameController.text, _emailController.text,
          _passwordController.text, _confirmPasswordController.text),);
    }
  }
  // void _attemptRegister() async {
  //   final result = await _service.register(
  //     _usernameController.text,
  //     _emailController.text,
  //     _passwordController.text,
  //     _confirmPasswordController.text,
  //   );
  //   final loggedIn = await _service.login(_emailController.text, _passwordController.text,);
  //   if (result == null) {
  //     if (mounted) {
  //       if(loggedIn){
  //         Navigator.pushNamed(context, '/homepage');
  //       }
  //
  //     }
  //   } else {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(result)),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final minSize = min(mediaQuery.size.width, mediaQuery.size.height);
    final maxSize = max(mediaQuery.size.width, mediaQuery.size.height);

    final List<Widget> children = [];
    children.add(
      Icon(
        Icons.person,
        size: minSize * 0.1,
      ),
    );
    children.add(
      CustomTextFormField(
        defaultText: 'username..',
        controller: _usernameController,
        validator: (value) => value!.isEmpty ? 'Name cannot be empty' : null,
        obscureText: false,
      ),
    );
    children.add(
      CustomTextFormField(
        defaultText: 'email..',
        controller: _emailController,
        validator: (value) => value!.contains('@') ? null : 'Enter a valid email',
        obscureText: false,
      ),
    );
    children.add(
      CustomTextFormField(
          defaultText: 'password..',
          controller: _passwordController,
          validator: (value) => value!.length < 4 ? 'Password too short' : null,
          obscureText: true),
    );
    children.add(
      CustomTextFormField(
        defaultText: 'confirm password..',
        controller: _confirmPasswordController,
        validator: (value) {
          final confirmPassword = value ?? '';
          if (confirmPassword.isEmpty) {
            return 'Please enter your password confirmation';
          }
          if (confirmPassword != _passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
        obscureText: true,
      ),
    );

    children.add(
      Row(
        children: [
          SizedBox(
            height: mediaQuery.size.height * 0.1,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: _attemptRegister,
              child: const Text('Register'),
            ),
            // CustomElevatedButton(
            //   buttonText: 'Register',
            //   destinationPage: HomePage(),
            // )
          ),
        ],
      ),
    );

    children.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account?',
            style: TextStyle(
              fontSize: maxSize * 0.02,
            ),
          ),
          const CustomTextButton(
            buttonText: 'Log in',
            destinationPage: LoginPage(),
          )
        ],
      ),
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
      width: mediaQuery.size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.lightGreen[200],
        borderRadius: BorderRadius.circular(40),
      ),
      child: mainColumn,
    );

    final mainView = BlocListener<UserBloc, UserState>(
      listener: (context, state) {
      // if (state is UserRegistrationInProgress) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Registration is in progress...')),
      //   );
      // } else if (state is UserRegistrationSuccess) {
        if (state is UserRegistrationSuccess) {
          final userName = state.userName;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Successful registration as $userName!')),
          );
          Navigator.pushReplacementNamed(context, '/homepage');
        } else if (state is UserRegistrationFailure) {
          final errorStr = state.error;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorStr)),
          );
        }
      },
      child: SingleChildScrollView(child: mainContainer),
    );

    return mainView;
  }
}
//     final mainContainer = Container(
//       padding: EdgeInsets.all(minSize * 0.03),
//       width: mediaQuery.size.width * 0.8,
//       decoration: BoxDecoration(
//         color: Colors.lightGreen[200],
//         borderRadius: BorderRadius.circular(40),
//       ),
//       child: mainColumn,
//     );
//
//     return SingleChildScrollView(child: mainContainer);
//   }
// }
