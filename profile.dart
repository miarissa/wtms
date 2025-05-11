import 'package:flutter/material.dart';
import 'login.dart'; 
import '/model/worker.dart'; 

class ProfileScreen extends StatelessWidget {
  final Worker worker;

  const ProfileScreen({super.key, required this.worker});

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false, 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Profile'),
        backgroundColor: Colors.lightGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center( 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${worker.iD}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Full Name: ${worker.name}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Email: ${worker.email}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Phone: ${worker.phone}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Address: ${worker.address}', style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
