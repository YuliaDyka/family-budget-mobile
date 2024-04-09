class User {
  String name;
  final String email;
  late final String password;

  User({required this.name, required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
  };

  static User fromJson(Map<String, dynamic> json) => User(
    name: json['name'].toString(),
    email: json['email'].toString(),
    password: json['password'].toString(),
  );

  void updateUserInfo(String newName, String newPassword) {
    name = newName;
    password = newPassword;
  }
}
