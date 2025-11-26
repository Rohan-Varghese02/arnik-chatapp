import 'package:flutter/material.dart';

class AuthNavigationLinkWidget extends StatelessWidget {
  final String leadingText;
  final String linkText;
  final VoidCallback onTap;

  const AuthNavigationLinkWidget({
    super.key,
    required this.leadingText,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: leadingText,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
            children: [
              TextSpan(
                text: ' $linkText',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

