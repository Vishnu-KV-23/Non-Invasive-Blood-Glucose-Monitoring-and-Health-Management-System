import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:phase_1_app/utils/config.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, this.textFieldColor = Colors.white});

  final Color textFieldColor;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _obscurePass = true;
  bool _isLoading = false;
  String _loginMessage = "";
  Color _messageColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Email Field
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              cursorColor: Config.primaryColor,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Enter your email',
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined, color: Config.primaryColor),
                filled: true,
                fillColor: widget.textFieldColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                if (!emailRegex.hasMatch(value.trim())) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Password Field
            TextFormField(
              controller: _passController,
              keyboardType: TextInputType.visiblePassword,
              cursorColor: Config.primaryColor,
              obscureText: _obscurePass,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Enter your password',
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline, color: Config.primaryColor),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() => _obscurePass = !_obscurePass);
                  },
                  icon: Icon(
                    _obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: _obscurePass ? Colors.black38 : Config.primaryColor,
                  ),
                ),
                filled: true,
                fillColor: widget.textFieldColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your password';
                }
                if (value.trim().length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Config.primaryColor,
                  elevation: 5,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Sign In',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Display Login Status Message
            if (_loginMessage.isNotEmpty)
              Text(
                _loginMessage,
                style: TextStyle(color: _messageColor, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _loginMessage = "";
      });

      final email = _emailController.text.trim().toLowerCase();
      final password = _passController.text.trim();
      const url = 'http://192.168.231.185:5001/login'; // Flask backend URL

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        );

        final result = jsonDecode(response.body);
        print("Response: ${response.body}"); // Debugging API response

        if (response.statusCode == 200 && result['success'] == true) {
          setState(() {
            _loginMessage = "Login successful!";
            _messageColor = Colors.green;
          });
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              Navigator.of(context).pushReplacementNamed('main');
            }
          });
        } else {
          setState(() {
            _loginMessage = result['message'] ?? "Invalid credentials. Try again.";
            _messageColor = Colors.red;
          });
        }
      } catch (e) {
        setState(() {
          _loginMessage = "Error: $e";
          _messageColor = Colors.red;
        });
      }

      setState(() => _isLoading = false);
    }
  }
}
