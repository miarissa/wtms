import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:worker_task/screens/profile_screen.dart';
import 'package:worker_task/screens/submission_history.dart';
import 'package:worker_task/screens/tasks_screen.dart';
import 'package:worker_task/utils/shared_prefs.dart';

class HomeScreen extends StatefulWidget {
  final String workerId;
  const HomeScreen({super.key, required this.workerId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? profilePicUrl;
  String name = '';
  String id = '';
  int pendingTaskCount = 0;
  int _selectedIndex = 0;

  static const String baseUrl = "http://10.0.2.2/wtms_backend";

@override
void initState() {
  super.initState();
  print('DEBUG: HomeScreen started with workerId = ${widget.workerId}');
  _fetchProfile();
  _fetchPendingTasks();
}

  Future<void> _fetchProfile() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get_profile.php'),
        body: {'id': widget.workerId},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          name = data['full_name'] ?? '';
          id = data['id']?.toString() ?? widget.workerId;
          if (data['profile_pic'] != null && data['profile_pic'].toString().isNotEmpty) {
            profilePicUrl = '$baseUrl/uploads/${data['profile_pic']}';
          } else {
            profilePicUrl = null;
          }
        });
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  Future<void> _fetchPendingTasks() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get_tasks.php'),
        body: {'worker_id': widget.workerId},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final tasks = data['tasks'] as List<dynamic>;
        int pendingCount = tasks.where((task) => task['status'] == 'pending').length;
        setState(() {
          pendingTaskCount = pendingCount;
        });
      }
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'Tasks';
      case 2:
        return 'History';
      case 3:
        return 'Profile';
      default:
        return 'Home';
    }
  }

  Widget _buildHomeContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: profilePicUrl != null
                      ? NetworkImage(profilePicUrl!)
                      : const AssetImage('assets/images/default_profile.png') as ImageProvider,
                ),
                const SizedBox(height: 12),
                Text(
                  name.isNotEmpty ? name : 'Loading...',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text('ID: $id', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Pending Tasks: $pendingTaskCount',
                    style: const TextStyle(fontSize: 18, color: Colors.blueAccent, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return TasksScreen(workerId: widget.workerId);
      case 2:
        return SubmissionHistory(workerId: widget.workerId);
      case 3:
        return ProfileScreen(workerId: widget.workerId);
      default:
        return _buildHomeContent();
    }
  }

  void _logout() async {
  // Clear login status
  await SharedPrefs.saveLoginStatus(false);
  await SharedPrefs.clearSavedCredentials();

  // Navigate back to LoginScreen
  if (!mounted) return;
  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_getAppBarTitle()),
      actions: [
    IconButton(
      icon: const Icon(Icons.logout),
      onPressed: _logout,
      tooltip: 'Logout',
    ),
  ],),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: const Color.fromARGB(255, 173, 157, 246),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
