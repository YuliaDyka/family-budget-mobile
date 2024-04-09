import 'package:flutter/material.dart';

class ProfileBalance extends StatelessWidget {
  const ProfileBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        Container(
          height: 110,
          width: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.lightGreen[400],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Your current balance: \$10000',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Some very important text..',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          height: 55,
          width: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.lightGreen[200],
          ),
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
                const Text('Add new card', style: TextStyle(fontSize: 17),),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
