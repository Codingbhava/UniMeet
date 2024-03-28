import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:unimeet/components/textfield.dart';
import 'package:unimeet/constants/data.dart';
import 'package:unimeet/database/auth.dart';

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
  var showProgress = false;
  String error = "";
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool _isVerify(String email, String pass, String username) {
    if (email == "" || email.isEmpty) {
      setState(() {
        error = "Enter a Email";
      });
      return false;
    }
    if (pass == "" || pass.isEmpty) {
      setState(() {
        error = "Enter a Password";
      });
      return false;
    }
    if (username == "" || username.isEmpty) {
      setState(() {
        error = "Enter a UserName";
      });
      return false;
    }
    return true;
  }

  Future<void> _google() async {
    try {
      setState(() {
        showProgress = true;
      });

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        throw FirebaseAuthException(
          code: 'google-sign-in-failed',
          message: 'Google Sign In failed.',
        );
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      GoogleData(userCredential.user!);
      setState(() {
        showProgress = false;
      });
    } catch (e) {
      print(e.toString());

      String errorMessage = "An error occurred during registration";

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'network-request-failed':
            errorMessage = "Check your internet connection";
            break;
          case 'google-sign-in-failed':
            errorMessage = "Google Sign In failed";
            break;
          default:
            errorMessage = "Error: ${e.message}";
          // Add more cases for other possible error codes
        }
        setState(() {
          error = errorMessage;
        });
      }
    } finally {}
  }

  Future _signup() async {
    if (_isVerify(_email.text, _password.text, _username.text)) {
      try {
        setState(() {
          showProgress = true;
        });

        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text.trim(),
          password: _password.text.trim(),
        );
        userCredential.user!.updateDisplayName(_username.text.trim());

        RegisterData(
            userCredential.user!, _username.text.trim(), _email.text.trim());

        setState(() {
          showProgress = false;
        });
      } catch (e) {
        print(e.toString());
        String errorMessage = "An error occurred during registration";

        // Check specific error codes and customize the error message accordingly
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'weak-password':
              errorMessage = "Password should be at least 6 characters.";
              break;
            case 'email-already-in-use':
              errorMessage = "email id already used  ";
              break;
            case 'internal-error':
              errorMessage = "Check Internet";
              break;
            case 'invalid-email':
              errorMessage = "Invalid password. Please try again.";
              break;
            default:
              errorMessage =
                  "An error occurred during registration: ${e.message}";
            // Add more cases for other possible error codes
          }
        }

        setState(() {
          error = errorMessage;
        });
      } finally {
        setState(() {
          showProgress = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    _username.dispose();
    super.dispose();
  }

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
              if (showProgress) LinearProgressIndicator(),
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
              if (error.isNotEmpty)
                Row(
                  children: [
                    Text(
                      error,
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
                          onPressed: _signup, child: Text("Sign Up"))),
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
                          onPressed: _google,
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
