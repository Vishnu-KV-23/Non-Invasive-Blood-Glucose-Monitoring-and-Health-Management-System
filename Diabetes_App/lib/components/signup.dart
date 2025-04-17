import 'package:flutter/material.dart';
import 'package:phase_1_app/utils/config.dart';
import 'package:phase_1_app/utils/text.dart';

class SignupForm extends StatefulWidget {
  final Color textFieldColor;
  final VoidCallback? onSignUpSuccess;

  const SignupForm({super.key, required this.textFieldColor, this.onSignUpSuccess});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void handleSignup() {
    // Handle user signup logic here (API call)
    print("Sign Up clicked!");
      bool signupSuccess = true; 

  if (signupSuccess) {
    widget.onSignUpSuccess?.call(); // Trigger navigation or success callback
  }
}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: "Full Name",
            filled: true,
            fillColor: widget.textFieldColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        Config.spaceSmall,
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: "Email",
            filled: true,
            fillColor: widget.textFieldColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        Config.spaceSmall,
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Password",
            filled: true,
            fillColor: widget.textFieldColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        Config.spaceSmall,
        ElevatedButton(
          onPressed: handleSignup,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text("Sign Up", style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ],
    );
  }
}
