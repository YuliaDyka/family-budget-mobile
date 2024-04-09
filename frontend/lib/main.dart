import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab1/pages/home_page.dart';
import 'package:lab1/pages/login_page.dart';
import 'package:lab1/pages/management/user_bloc.dart';
import 'package:lab1/pages/profile_page.dart';
import 'package:lab1/pages/register_page.dart';
import 'package:lab1/service/logic_service.dart';

// import 'package:lab1/service/logic_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'model/user.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LogicService>(
          create: (_) => MyService(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<UserBloc>(
            create: (context) => UserBloc(context.read<LogicService>()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Family Budget App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.lightGreen.shade100,
            ),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
          routes: {
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/profilepage': (context) => const ProfilePage(),
            '/homepage': (context) => const HomePage(),
          },
        ),

      ),
    );
    //   MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Family Budget App',
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(
    //       seedColor: Colors.lightGreen.shade100,
    //     ),
    //     useMaterial3: true,
    //   ),
    //   home: SplashScreen(),
    //   routes: {
    //     '/login': (context) => const LoginPage(),
    //     '/register': (context) => const RegisterPage(),
    //     '/profilepage': (context) => const ProfilePage(),
    //     '/homepage': (context) => const HomePage(),
    //   },
    //   home: const MyHomePage(title: 'Login Page'),
    // );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool?>(
      future: _getUserAndNavigate(context),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null && snapshot.data == true) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }

  Future<bool?> _getUserAndNavigate(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final lastLoggedInUserEmail = prefs.getString('lastLoggedInUser');

    if (lastLoggedInUserEmail != null) {
      final hasInternetConnection = await _checkInternetConnection();
      if (!hasInternetConnection) {
        _showNoInternetDialog(context);
        return true;
      }
      final userString = prefs.getString(lastLoggedInUserEmail);
      if (userString != null) {
        final Map<String, dynamic> userMap = jsonDecode(userString) as Map<String, dynamic>;
        final currentUser = User.fromJson(userMap);

        Navigator.pushReplacementNamed(context, '/homepage');
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  void _showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Connection error'),
          content: Text('Check please your internet connection'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}

// class SplashScreen extends StatelessWidget {
//   final UserStorageService userStorageService = MyUserStorageService();
//
//   SplashScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<bool>(
//       future: userStorageService.isLoggedIn(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // Показувати завантажувач під час перевірки статусу логування
//           return CircularProgressIndicator();
//         } else {
//           if (snapshot.hasError) {
//             // Обробка помилки, якщо виникла під час перевірки статусу логування
//             return Text('Error: ${snapshot.error}');
//           } else {
//             // Якщо користувач вже увійшов у систему, переходьте на головну сторінку
//             if (snapshot.data == true) {
//               return HomePage();
//             } else {
//               // Якщо користувач ще не увійшов у систему, переходьте на сторінку входу
//               return LoginPage();
//             }
//           }
//         }
//       },
//     );
//   }
// }
