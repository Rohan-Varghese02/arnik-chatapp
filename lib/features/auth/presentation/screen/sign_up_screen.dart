import 'package:chat_app/core/validator/validator.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/auth/presentation/widget/auth_button.dart';
import 'package:chat_app/features/auth/presentation/widget/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController cnfrmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('R E G I S T E R', style: TextStyle(color: Colors.white)),
        leading: SizedBox(),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: .center,
              children: [
                Text(
                  'Register your account',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                AuthTextField(
                  hintText: 'Enter name',
                  controller: nameController,
                  validator: validateName,
                ),
                SizedBox(height: 10),
                AuthTextField(
                  hintText: 'Enter email',
                  controller: emailController,
                  validator: validateEmail,
                ),
                SizedBox(height: 10),
                AuthTextField(
                  hintText: 'Enter password',
                  controller: passController,
                  validator: validatePassword,
                ),
                SizedBox(height: 10),
                AuthTextField(
                  hintText: 'Confirm password',
                  controller: cnfrmController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter confirm password';
                    }
                    if (passController.text != value) {
                      return 'Passwords does not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                AuthButton(
                  text: 'Sign up',
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(
                        AuthSignIn(
                          name: nameController.text,
                          email: emailController.text,
                          password: passController.text,
                        ),
                      );
                      print('true');
                      Navigator.of(context).pop();
                    }
                  },
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
