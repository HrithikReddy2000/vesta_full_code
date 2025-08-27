import 'package:flutter/material.dart';
import 'package:projectmercury/screens/sign_in_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color.fromARGB(255, 1, 147, 225),
              Color.fromARGB(255, 0, 41, 107),
            ],
            radius: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const Spacer(flex: 2),
              const Text('Welcome to',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
              const Image(image: AssetImage('assets/logo.png')),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () async {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => const MySignInScreen(),
                      );
                    },
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
