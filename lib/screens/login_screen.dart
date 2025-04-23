import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  late AnimationController _controller;
  late Animation<Offset> _animation;

  String emailOrUsername = '';
  String password = '';
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<Offset>(begin: Offset(0, 2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.signInWithEmailAndPassword(
          email: emailOrUsername,
          password: password,
        );
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        setState(() => errorMessage = 'Login failed. Check your credentials.');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 350,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white54),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'Login to Your Account',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      decoration: _inputDecoration('Email or Username', Icons.person),
                      onChanged: (val) => emailOrUsername = val,
                      validator: (val) => val!.isEmpty ? 'Enter your email or username' : null,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: _inputDecoration('Password', Icons.lock),
                      obscureText: true,
                      onChanged: (val) => password = val,
                      validator: (val) => val!.isEmpty ? 'Enter your password' : null,
                    ),
                    SizedBox(height: 30),
                    SlideTransition(
                      position: _animation,
                      child: ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Login', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
                      child: Text("Don't have an account? Register", style: TextStyle(color: Colors.white)),
                    ),
                    if (errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(errorMessage, style: TextStyle(color: Colors.red)),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.white),
      filled: true,
      fillColor: Colors.white.withOpacity(0.8),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
