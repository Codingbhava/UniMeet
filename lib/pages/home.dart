import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unimeet/constants/data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton.icon(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.popAndPushNamed(context, '/usercheck');
          },
          icon: Icon(Icons.add),
          label: Text("New Meet")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(172, 255, 255, 89).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(100)),
                  child: ListTile(
                    leading: Icon(Icons.menu),
                    title: Text("Enter a Code"),
                    trailing: CircleAvatar(
                      child: Text("O"),
                      radius: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Column(
                    children: [],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
