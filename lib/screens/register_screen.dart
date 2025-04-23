import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  String fullName = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String errorMessage = '';

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      if (password != confirmPassword) {
        setState(() => errorMessage = 'Passwords do not match!');
        return;
      }

      try {
        await _auth.createUserWithEmailAndPassword(email: email, password: password);
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        setState(() => errorMessage = 'Registration failed. Try again.');
      }
    }
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
                      'Create Your Account',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      decoration: _inputDecoration('Full Name', Icons.person),
                      onChanged: (val) => fullName = val,
                      validator: (val) => val!.isEmpty ? 'Enter your name' : null,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: _inputDecoration('Email', Icons.email),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (val) => email = val,
                      validator: (val) => val!.isEmpty ? 'Enter a valid email' : null,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: _inputDecoration('Password', Icons.lock),
                      obscureText: true,
                      onChanged: (val) => password = val,
                      validator: (val) => val!.length < 6 ? 'Password must be at least 6 characters' : null,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: _inputDecoration('Confirm Password', Icons.lock),
                      obscureText: true,
                      onChanged: (val) => confirmPassword = val,
                      validator: (val) => val!.isEmpty ? 'Confirm your password' : null,
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Register', style: TextStyle(fontSize: 18)),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                      child: Text("Already have an account? Login", style: TextStyle(color: Colors.white)),
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
