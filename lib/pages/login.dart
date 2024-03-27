import 'package:flutter/material.dart';
import 'package:unimeet/components/textfield.dart';
import 'package:unimeet/constants/data.dart';

class SignIn extends StatefulWidget {
  final VoidCallback showSignUp;
  const SignIn({super.key, required this.showSignUp});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Text(
                    "Sign In",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("No account?"),
                  TextButton(
                      onPressed: widget.showSignUp, child: Text("Make account"))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              FieldForm(
                Label: "Email",
                isPass: false,
                controller: _email,
              ),
              SizedBox(
                height: 10,
              ),
              FieldForm(
                Label: "Password",
                isPass: true,
                controller: _password,
              ),
              if (false)
                Row(
                  children: [
                    Text(
                      "error",
                      style: TextStyle(color: Colors.red[400]),
                    ),
                  ],
                ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {}, child: Text("Sign In"))),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () {}, child: Text("Forget Password?")),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "-OR-",
                style: TextStyle(fontSize: 20, color: text),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {},
                          child: Text("Sign In with Google"))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
