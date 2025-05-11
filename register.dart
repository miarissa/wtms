import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final String apiUrl = "http://10.0.2.2/wtms/register.php";

  Future<void> _registerUser() async {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "name": _nameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "phone": _phoneController.text,
        "address": _addressController.text,
      },
    );

    final jsonResponse = json.decode(response.body);

    if (jsonResponse['status'] == 'success') {
      // Navigate to login screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration successful! Redirecting...")),
      );
      Future.delayed(const Duration(seconds: 2), () {
  Navigator.pushReplacementNamed(context, '/login');
});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed: ${jsonResponse['message'] ?? 'Unknown error'}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register"),
      backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            TextField(controller: _phoneController, decoration: const InputDecoration(labelText: "Phone")),
            TextField(controller: _addressController, decoration: const InputDecoration(labelText: "Address")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerUser,
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
