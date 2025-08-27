import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class MySignInScreen extends StatelessWidget {
  const MySignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providers: [
        EmailAuthProvider(), // ✅ Not EmailProviderConfiguration
      ],
    );
  }
}
