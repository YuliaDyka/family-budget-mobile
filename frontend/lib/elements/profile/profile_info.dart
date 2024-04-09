import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab1/model/user.dart';
import 'package:lab1/pages/management/user_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../pages/management/user_bloc.dart';
import '../../pages/management/user_state.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({super.key});

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  User? _user;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLoggedInUserEmail = prefs.getString('lastLoggedInUser');

    if (lastLoggedInUserEmail != null) {
      final userString = prefs.getString(lastLoggedInUserEmail);
      if (userString != null) {
        final Map<String, dynamic> userMap = jsonDecode(userString) as Map<String, dynamic>;
        setState(() {
          _user = User.fromJson(userMap);
        });
      }
    }
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLoggedInUserEmail = prefs.getString('lastLoggedInUser');

    if (lastLoggedInUserEmail != null) {
      final userString = prefs.getString(lastLoggedInUserEmail);
      if (userString != null) {
        final Map<String, dynamic> userMap = jsonDecode(userString) as Map<String, dynamic>;
        final currentUser = User.fromJson(userMap);

        final updatedName = _nameController.text.isNotEmpty ? _nameController.text : currentUser.name;

        final updatedPassword = _passwordController.text.isNotEmpty ? _passwordController.text : currentUser.password;

        if (updatedName != currentUser.name ||
            (updatedPassword != currentUser.password && updatedPassword.length >= 4)) {
          final updatedUser = User(
            name: updatedName,
            email: currentUser.email,
            password: updatedPassword,
          );
          context.read<UserBloc>().add(EditUserEvent(updatedUser));
          // final userId = await _service.getUserId(
          //      currentUser.email);
          //  final id = userId as int;
          //  final result = await _service.updateUserData(id, updatedName,
          //      currentUser.email, updatedPassword);
          //
          //  await prefs.setString(
          //    lastLoggedInUserEmail,
          //    jsonEncode(updatedUser.toJson()),
          //  );

          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //     content: Text('Profile updated successfully'),),);
        } else if (updatedPassword.length < 4) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password should be at least 4 characters long'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No changes made'),
            ),
          );
        }
      }
    }
  }

  Future<void> _reloadUserData() async {
    await _loadUserData();
    setState(() {});
  }

  Future<void> _logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('lastLoggedInUser');
    await _reloadUserData();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        // if (state is EditUserInProgressState) {
        //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     content: Text('The profile is updating...'),),);
        // } else if (state is EditUserSuccessState) {
        if (state is EditUserSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
            ),
          );
          _loadUserData();
        } else if (state is EditUserFailedState) {
          final errorStr = state.error;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profile update failed: $errorStr'),
            ),
          );
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              if (_user == null)
                const CircularProgressIndicator()
              else
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Icon(
                          Icons.perm_contact_calendar_outlined,
                          size: 140,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'name:',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.green.withOpacity(0.6),
                              ),
                            ),
                            Text(
                              _user!.name,
                              style: const TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              'email:',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.green.withOpacity(0.6),
                              ),
                            ),
                            Text(
                              _user!.email,
                              style: const TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Edit Profile'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Name',
                                    ),
                                  ),
                                  TextField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Password',
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () async {
                                    await _saveUserData();
                                    await _reloadUserData();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Save'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Edit Profile'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
