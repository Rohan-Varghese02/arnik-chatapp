import 'package:chat_app/core/validator/validator.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/auth/presentation/widget/auth_button.dart';
import 'package:chat_app/features/auth/presentation/widget/auth_form_container_widget.dart';
import 'package:chat_app/features/auth/presentation/widget/auth_header_widget.dart';
import 'package:chat_app/features/auth/presentation/widget/auth_navigation_link_widget.dart';
import 'package:chat_app/features/auth/presentation/widget/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.blue.shade100,
              Colors.white,
            ],
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
                        title: 'Create Account',
                        subtitle: 'Sign up to get started',
                      ),
                      AuthFormContainerWidget(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AuthTextField(
                                header: 'Name',
                                hintText: 'Enter your name',
                                controller: _nameController,
                                validator: validateName,
                                keyboardType: TextInputType.name,
                              ),
                              AuthTextField(
                                header: 'Email',
                                hintText: 'Enter your email',
                                controller: _emailController,
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
                              AuthTextField(
                                header: 'Confirm Password',
                                hintText: 'Confirm your password',
                                controller: _confirmController,
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (_passController.text != value) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 8),
                              AuthButton(
                                text: 'Sign Up',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                          AuthSignIn(
                                            name: _nameController.text,
                                            email: _emailController.text,
                                            password: _passController.text,
                                          ),
                                        );
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                              const SizedBox(height: 24),
                              AuthNavigationLinkWidget(
                                leadingText: 'Already have an account?',
                                linkText: 'Login',
                                onTap: () {
                                  Navigator.of(context).pop();
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
    );
  }
}
