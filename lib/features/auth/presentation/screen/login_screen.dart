import 'dart:developer';

import 'package:chat_app/core/validator/validator.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/auth/presentation/screen/sign_up_screen.dart';
import 'package:chat_app/features/auth/presentation/widget/auth_button.dart';
import 'package:chat_app/features/auth/presentation/widget/auth_form_container_widget.dart';
import 'package:chat_app/features/auth/presentation/widget/auth_google.dart';
import 'package:chat_app/features/auth/presentation/widget/auth_header_widget.dart';
import 'package:chat_app/features/auth/presentation/widget/auth_navigation_link_widget.dart';
import 'package:chat_app/features/auth/presentation/widget/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is GoogleSignInSuccess) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (state is GoogleSignInFailed) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is LoginSuccess) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (state is LoginFailed) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade50, Colors.blue.shade100, Colors.white],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const AuthHeaderWidget(
                          title: 'Welcome Back',
                          subtitle: 'Sign in to continue',
                        ),
                        AuthFormContainerWidget(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                AuthTextField(
                                  header: 'Email',
                                  hintText: 'Enter your email',
                                  controller: _emailController,
                                  obscureText: false,
                                  validator: validateEmail,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                AuthTextField(
                                  header: 'Password',
                                  hintText: 'Enter your password',
                                  controller: _passController,
                                  obscureText: true,
                                  validator: validatePassword,
                                ),
                                const SizedBox(height: 8),
                                AuthButton(
                                  text: 'Login',
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      log(_emailController.text);
                                      context.read<AuthBloc>().add(
                                        AuthLogin(
                                          email: _emailController.text,
                                          pasword: _passController.text,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 20),
                                GoogleButton(
                                  onTap: () {
                                    context.read<AuthBloc>().add(
                                      GoogleSignInRequested(),
                                    );
                                  },
                                ),
                                const SizedBox(height: 24),
                                AuthNavigationLinkWidget(
                                  leadingText: "Don't have an account?",
                                  linkText: 'Create an account',
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
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