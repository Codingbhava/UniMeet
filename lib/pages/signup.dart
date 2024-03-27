import 'package:flutter/material.dart';
import 'package:unimeet/components/textfield.dart';
import 'package:unimeet/constants/data.dart';

class SignUp extends StatefulWidget {
  final VoidCallback showSignIn;
  const SignUp({super.key, required this.showSignIn});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _username = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: widget.showSignIn,
                      icon: Icon(Icons.arrow_back_ios_new)),
                  Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              FieldForm(
                Label: "Username",
                isPass: false,
                controller: _username,
              ),
              SizedBox(
                height: 10,
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
                          onPressed: () {}, child: Text("Sign Up"))),
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
                          child: Text("Sign Up with Google"))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
