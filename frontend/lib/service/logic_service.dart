import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:lab1/model/user.dart';
//import 'package:lab1/service/user_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LogicService {
  Future<String?> register(String name, String email, String password,
      String confirmPassword,);

  Future<bool> login(String email, String password);

  Future<bool> loginOffline(String email, String password);

  Future<bool> updateUserData(int id, String name, String email, String password);

  Future<dynamic> getUserId(String email);

  Future<User?>  getUser();

  Future<bool> checkInternetConnection();

  Future<void> storeUpdatedUser(User updatedUser);
}

class MyService implements LogicService {
  //final UserStorageService _userStorageService = MyUserStorageService();
  final String _serviceUrl = 'http://10.0.2.2:5000/user';

  @override
  Future<String?> register(String name, String email, String password,
      String confirmPassword,) async {
    if (email.isEmpty || !email.contains('@')) {
      return 'Invalid email';
    }
    if (name.isEmpty) {
      return 'Invalid name';
    }
    if (password.length < 4) {
      return 'Password must be at least 4 characters long';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    final prefs = await SharedPreferences.getInstance();
    // final existingUser = await _userStorageService.getUser(email);
    // if (existingUser != null) {
    //   return 'User already exists';
    // }
    final response = await http.post(
      Uri.parse('$_serviceUrl'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final newUser = User(name: name, email: email, password: password);
      //await _userStorageService.saveUser(newUser);
      await prefs.setString(email, jsonEncode(newUser.toJson()));
      await prefs.setString('lastLoggedInUser', email);
      return null;
    } else {
      return 'Failed to register user';
    }
    // final newUser = User(name: name, email: email, password: password);
    // await _userStorageService.saveUser(newUser);
    // return null;

  }

  @override
  Future<bool> loginOffline(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(email);
    if (userString != null) {
      final userMap = jsonDecode(userString) as Map<String, dynamic>;
      if (password == userMap['password']) {
        await prefs.setString('lastLoggedInUser', email);
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse('$_serviceUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      await prefs.setString('lastLoggedInUser', email);
      return true;
    } else {
      return false;
    }
  }
  @override
  Future<bool> updateUserData(int id, String name, String email, String password) async{
    final prefs = await SharedPreferences.getInstance();
    final response = await http.put(
        Uri.parse('$_serviceUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),);
    if (response.statusCode == 200 || response.statusCode == 201) {
      // await prefs.setString('lastLoggedInUser', email);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<dynamic> getUserId(String email) async {
    final response = await http.get(
      Uri.parse('$_serviceUrl/by_email/$email'),
      headers: {'Content-Type': 'application/json'},

    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);

      return data['id'];
    } else {
      return -1;
    }
  }

  @override
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLoggedInUserEmail = prefs.getString('lastLoggedInUser');
    if (lastLoggedInUserEmail != null) {
      final userString = prefs.getString(lastLoggedInUserEmail);
      if (userString != null) {
        final Map<String, dynamic> userMap =
        jsonDecode(userString) as Map<String, dynamic>;
        return User.fromJson(userMap);
      }
    }
    return null;
  }

  @override
  Future<bool> checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Future<void> storeUpdatedUser(User updatedUser) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(updatedUser.email, jsonEncode(updatedUser.toJson()));
  }
// Future<bool> checkAutoLogin() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final lastLoggedInUserEmail = prefs.getString('lastLoggedInUser');
  //   return lastLoggedInUserEmail != null;
  // }

}
