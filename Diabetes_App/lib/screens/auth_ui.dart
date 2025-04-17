import 'package:flutter/material.dart';
import 'package:phase_1_app/components/login.dart';
import 'package:phase_1_app/components/signup.dart'; 
import 'package:phase_1_app/utils/config.dart';
import 'package:phase_1_app/utils/text.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF0093AF), // Munsell Blue background
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Image.asset(
                    'assets/icon.png',
                    height: 200, // Increased size of the icon
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  AppText.enText['welcome_text']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Config.spaceSmall,
                Text(
                  AppText.enText['signIn_text']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
                Config.spaceSmall,

                // Toggle between Login & Sign Up Forms
                isLogin
                    ? LoginForm(textFieldColor: Colors.white.withOpacity(0.9))
                    : SignupForm(
                        textFieldColor: Colors.white.withOpacity(0.9),
                        onSignUpSuccess: () {
                          setState(() {
                            isLogin = true; // Switch to Login page after successful signup
                          });
                        },
                      ),

                Config.spaceSmall,
                Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin; // Toggle the form
                      });
                    },
                    child: Text(
                      isLogin
                          ? "Don't have an account? Sign Up"
                          : "Already have an account? Sign In",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
