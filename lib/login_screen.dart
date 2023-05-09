import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yellow_paper/home_screen.dart';
import 'package:yellow_paper/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool? success;
  String? userEmail;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String errorValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: const Text('Test sign in with email and password'),
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.center,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (String? value) {
                      if (value == null) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (String? value) {
                      if (value == null) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          _signInWithEmailAndPassword();
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      success == null ? '' : (success! ? 'Successfully signed in ' + userEmail! : errorValue),
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ],
              ),
            ),
            Center(
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                        return RegistrationScreen();
                      }));
                    },
                    child: Text("Register Now")))
          ],
        ),
      ),
    );
  }

  void _signInWithEmailAndPassword() async {
    try {
      setState(() {
        success = false;
      });
      final user = (await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      ))
          .user;

      if (user != null) {
        setState(() {
          success = true;
          userEmail = user.email;
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            return HomeScreen();
          }));
        });
      } else {
        setState(() {
          success = false;
        });
      }
    } catch (e) {
      setState(() {
        errorValue = e.toString();
      });
    }
  }
}
