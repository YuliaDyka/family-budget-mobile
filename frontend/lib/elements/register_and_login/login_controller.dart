import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab1/elements/register_and_login/custom_text_field.dart';
import 'package:lab1/pages/management/user_bloc.dart';
import 'package:lab1/pages/register_page.dart';
import 'package:lab1/service/logic_service.dart';
import 'package:lab1/service/user_storage_service.dart';
import 'package:connectivity/connectivity.dart';

import '../../pages/management/user_event.dart';
import '../../pages/management/user_state.dart';

class LoginContainer extends StatefulWidget {
  const LoginContainer({super.key});

  @override
  State<LoginContainer> createState() => _LoginContainer();
}

class _LoginContainer extends State<LoginContainer> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _service = MyService();
  final _userStorageService = MyUserStorageService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  void _attemptLogin() async {
    FocusManager.instance.primaryFocus?.unfocus();
    // final hasInternetConnection = await _checkInternetConnection();
    // if (!hasInternetConnection) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('No internet connection!')),
    //   );
    // }

    final email = _emailController.text;
    final password = _passwordController.text;
    // final loggedIn =
    //     hasInternetConnection ? await _service.login(email, password) : await _service.loginOffline(email, password);

    // final errorMessage = await _authService.login(email, password);

    if (mounted) {
      // if (loggedIn) {
      //   final user = await _service.getUser();
      //   final userName = user?.name ?? 'User';
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Успішний вхід як $userName')),
      //   );
      //   Navigator.pushReplacementNamed(context, '/homepage');
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Invalid email or password')),
      //   );
      // }
      context.read<UserBloc>().add(LoginRequested(email, password));
    }
  }

  void _attemptRegister() async {
    final hasInternetConnection = await _checkInternetConnection();
    if (!hasInternetConnection) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection!')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const RegisterPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final minSize = min(mediaQuery.size.width, mediaQuery.size.height);
    final maxSize = max(mediaQuery.size.width, mediaQuery.size.height);

    final List<Widget> children = [];
    children.add(
      Icon(
        Icons.person,
        size: minSize * 0.15,
      ),
    );
    children.add(
      CustomTextField(
        defaultText: 'email..',
        controller: _emailController,
        obscureText: false,
      ),
    );
    children.add(CustomTextField(
      defaultText: 'password..',
      controller: _passwordController,
      obscureText: true,
    ));

    children.add(
      Row(
        children: [
          SizedBox(
            height: mediaQuery.size.height * 0.1,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: _attemptLogin,
              child: const Text('Log in'),
              // CustomElevatedButton(
              //   buttonText: 'Log in',
              //   destinationPage: HomePage(),
              // ),
            ),
          )
        ],
      ),
    );

    children.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'New user?',
            style: TextStyle(
              fontSize: maxSize * 0.02,
            ),
          ),
          TextButton(
            style: ButtonStyle(
              textStyle: MaterialStateProperty.all(
                TextStyle(
                  fontSize: maxSize * 0.02,
                ),
              ),
            ),
            onPressed: _attemptRegister,
            child: const Text('Register'),
          ),
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
        // if (state is LoginInProgress) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Login is in progress...')),
        //   );
        // } else if (state is LoginSuccess) {
        if (state is LoginSuccess) {
          final userName = state.userName;
          Navigator.pushReplacementNamed(context, '/homepage');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Success login as: $userName')),
          );
        } else if (state is LoginFailure) {
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
