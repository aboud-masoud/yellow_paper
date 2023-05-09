import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool? success;
  String userEmail = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String errorValue = "";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                  child: const Text('Submit'),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      _register();
                    }
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(success == null ? '' : (success! ? 'Successfully registered $userEmail' : errorValue)),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _register() async {
    try {
      setState(() {
        success = false;
      });
      final user = (await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      ))
          .user;

      if (user != null) {
        setState(() {
          success = true;
          userEmail = user.email!;
          Navigator.of(context).pop();
        });
      } else {
        setState(() {
          success = true;
        });
      }
    } catch (e) {
      errorValue = e.toString();
      if (e.toString() ==
          "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
        errorValue = "galaat bl email";
        setState(() {});
      }
    }
  }
}
