import 'package:flutter/material.dart';
import 'package:worker_task/models/worker.dart';
import 'package:worker_task/screens/home_screen.dart';
import 'package:worker_task/screens/register_screen.dart';
import 'package:worker_task/services/api_service.dart';
import 'package:worker_task/utils/shared_prefs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool rememberMe = false; 

  @override
  void initState() {
    super.initState();
    _loadRememberedCredentials(); 
  }

  void _loadRememberedCredentials() async {
    final savedEmail = await SharedPrefs.getSavedEmail();
    final savedPassword = await SharedPrefs.getSavedPassword();
    final savedRemember = await SharedPrefs.getRememberMe();

    if (savedRemember == true) {
      setState(() {
        rememberMe = true;
        _emailController.text = savedEmail ?? '';
        _passwordController.text = savedPassword ?? '';
      });
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      Worker? worker = await ApiService.loginWorker(
        email: _emailController.text,
        password: _passwordController.text,
      );

      setState(() => isLoading = false);

      if (worker != null) {
        await SharedPrefs.saveLoginStatus(true);
        await SharedPrefs.saveWorker(worker);

        if (rememberMe) {
          await SharedPrefs.saveSavedEmail(_emailController.text);
          await SharedPrefs.saveSavedPassword(_passwordController.text);
          await SharedPrefs.saveRememberMe(true);
        } else {
          await SharedPrefs.clearSavedCredentials();
        }

      //Debug print to check worker.id
        print('DEBUG: worker.id = ${worker.id}');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(workerId: worker.id),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login failed. Check credentials.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Welcome Back!",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: "Email"),
                      validator: (value) => value!.isEmpty || !value.contains('@')
                          ? 'Enter valid email'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: "Password"),
                      obscureText: true,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter your password' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value ?? false;
                            });
                          },
                        ),
                        const Text("Remember Me"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text("Login"),
                          ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterScreen()),
                        );
                      },
                      child: const Text("Don't have an account? Register"),
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
}
