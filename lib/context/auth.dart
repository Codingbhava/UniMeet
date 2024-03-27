import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unimeet/pages/home.dart';
import 'package:unimeet/subpages/authcheck.dart';

class UserCheck extends StatelessWidget {
  const UserCheck({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) =>
            snapshot.hasData ? Home() : AuthCheck());
  }
}
