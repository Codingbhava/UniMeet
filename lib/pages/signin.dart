import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:unimeet/components/textfield.dart';
import 'package:unimeet/constants/data.dart';
import 'package:unimeet/database/auth.dart';

class SignIn extends StatefulWidget {
  final VoidCallback showSignUp;
  const SignIn({super.key, required this.showSignUp});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var showProgress = false;
  String error = "";
  final GoogleSignIn googleSignIn = GoogleSignIn();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool _isEmail(String email) {
    if (email == "" || email.isEmpty) {
      setState(() {
        error = "Enter a Email";
      });
      return false;
    }
    return true;
  }

  bool _isVerify(String email, String pass) {
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
    return true;
  }

  Future<void> _resetpass() async {
    if (_isEmail(_email.text)) {
      try {
        setState(() {
          showProgress = true;
        });

        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _email.text.trim());
        setState(() {
          error = "send mail to ${_email.text} for reset password";
          showProgress = false;
        });
      } catch (e) {
        print(e.toString());
        String errorMessage = "An error occurred during registration";

        // Check specific error codes and customize the error message accordingly
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'user-not-found':
              errorMessage = "User not found. Please check your credentials.";
              break;
            case 'wrong-password':
              errorMessage = "Invalid password. Please try again.";
              break;
            case 'network-request-failed':
              errorMessage = "Check Internet";
              break;
            case 'invalid-email':
              errorMessage = "Invalid email. Please try again.";
              break;
            case 'invalid-credential':
              errorMessage = "Invalid credential. Please try again.";
              break;
            default:
              errorMessage = "An error occurred during registration: ${e.code}";
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

  Future _signin() async {
    if (_isVerify(_email.text, _password.text)) {
      try {
        setState(() {
          showProgress = true;
        });

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text.trim(),
          password: _password.text.trim(),
        );

        setState(() {
          showProgress = false;
        });
      } catch (e) {
        print(e.toString());
        String errorMessage = "An error occurred during registration";

        // Check specific error codes and customize the error message accordingly
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'user-not-found':
              errorMessage = "User not found. Please check your credentials.";
              break;
            case 'wrong-password':
              errorMessage = "Invalid password. Please try again.";
              break;
            case 'network-request-failed':
              errorMessage = "Check Internet";
              break;
            case 'invalid-email':
              errorMessage = "Invalid email. Please try again.";
              break;
            case 'invalid-credential':
              errorMessage = "Invalid credential. Please try again.";
              break;
            default:
              errorMessage = "An error occurred during registration: ${e.code}";
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
    super.dispose();
  }

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
              SizedBox(
                height: 5,
              ),
              if (error.isNotEmpty)
                Row(
                  children: [
                    SizedBox(width: 5),
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
                          onPressed: _signin, child: Text("Sign In"))),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: _resetpass, child: Text("Forget Password?")),
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
