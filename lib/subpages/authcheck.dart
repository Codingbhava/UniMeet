import 'package:flutter/material.dart';
import 'package:unimeet/pages/signin.dart';
import 'package:unimeet/pages/signup.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool showLoginPage = true;
  void togglePage() => setState(() {
        showLoginPage = !showLoginPage;
      });

  @override
  Widget build(BuildContext context) => showLoginPage
      ? SignIn(showSignUp: togglePage)
      : SignUp(showSignIn: togglePage);
}
