import 'package:flutter/material.dart';
import 'package:lab1/elements/profile/profile_balance.dart';
import 'package:lab1/elements/profile/profile_info.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: ProfileInfo(),
                      ),
                       Padding(
                        padding: EdgeInsets.all(15),
                        child: ProfileBalance(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
