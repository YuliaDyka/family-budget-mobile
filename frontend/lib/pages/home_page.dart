import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:lab1/elements/home/home_container.dart';
import 'package:lab1/pages/login_page.dart';
import 'package:lab1/pages/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  Future<void> onItemTapped(int index) async {
    final hasInternetConnection = await _checkInternetConnection();
    if (!hasInternetConnection && index == 1) { // Індекс 1 відповідає сторінці профілю

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
      return;
    }
    setState(() {
      selectedIndex = index;
    });
  }

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  void _logout() async {

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('lastLoggedInUser');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (context) => const LoginPage()),
    );
  }


  Future<void> _confirmLogout() async {
    final hasInternetConnection = await _checkInternetConnection();
    if (!hasInternetConnection) {
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
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log out'),
          content: Text('Are you sure you wanna log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: _confirmLogout,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red[400],
      ),
      child: const Text('Logout'),
    );
  }

  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);
    final double bottomNavigationBarHeight =
    min(80, mediaQuery.size.height * 0.1,);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen.shade300,
          title: const Text('Family Budget'),
          automaticallyImplyLeading: false,
           actions: <Widget>[
             _buildLogoutButton(),
           ],
        ),
        body: [
          /// Home page
          const SingleChildScrollView(
            child: Column(
              children: [
                HomeContainer(),
              ],
            ),
          )
          /// Profile page
          ,const SingleChildScrollView(
            child: Column(
              children: [
                ProfilePage(),
              ],
            ),
          )
        ,][selectedIndex],
        bottomNavigationBar: SizedBox(
          height: bottomNavigationBarHeight,
          child: BottomNavigationBar(
            landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.supervised_user_circle),
                label: 'Profile',
              ),
            ],
            currentIndex: selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: onItemTapped,
          ),
        ),
    );
  }
}
