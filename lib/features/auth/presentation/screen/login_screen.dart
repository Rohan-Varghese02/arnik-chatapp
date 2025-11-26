import 'dart:developer';

import 'package:chat_app/core/validator/validator.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/auth/presentation/screen/sign_up_screen.dart';
import 'package:chat_app/features/auth/presentation/widget/auth_button.dart';
import 'package:chat_app/features/auth/presentation/widget/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('L O G I N', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),

      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          child: Container(
            margin: EdgeInsets.all(15),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login to your account',
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  AuthTextField(
                    hintText: 'Enter Email',
                    controller: emailController,
                    obscureText: false,
                    validator: validateEmail,
                  ),
                  SizedBox(height: 10),
                  AuthTextField(
                    hintText: 'Enter Password',
                    controller: passController,
                    validator: validatePassword,
                  ),
                  SizedBox(height: 10),
                  AuthButton(
                    text: 'Login',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        log(emailController.text);
                        context.read<AuthBloc>().add(
                          AuthLogin(
                            email: emailController.text,
                            pasword: passController.text,
                          ),
                        );
                      }
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Dont have an account? ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: 'Create an account',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
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
      ),
    );
  }
}
