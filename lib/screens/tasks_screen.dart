import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:worker_task/models/tasks.dart';
import 'dart:convert';
import 'submission_screen.dart';

class TasksScreen extends StatefulWidget {
  final String workerId;
  const TasksScreen({super.key, required this.workerId});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Tasks> _tasks = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/wtms_backend/get_tasks.php'),
        body: {'worker_id': widget.workerId},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final taskList = data['tasks'] as List;
        setState(() {
          _tasks = taskList.map((json) => Tasks.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error fetching tasks: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assigned Tasks')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    final isCompleted = task.status == 'completed';

                    return Card(
                      elevation: 6,
                      margin: const EdgeInsets.all(8),
                      child: InkWell(
                        onTap: isCompleted
                            ? null // disable tap if completed
                            : () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SubmissionScreen(
                                      workId: task.id,
                                      workerId: int.parse(widget.workerId),
                                      taskTitle: task.title,
                                    ),
                                  ),
                                );
                                if (result == true) _fetchTasks();
                              },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Task ID: ${task.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('Title: ${task.title}'),
                              Text('Description: ${task.description}'),
                              Text('Date Assigned: ${task.dateAssigned}'),
                              Text('Due Date: ${task.dueDate}'),
                              Text(
                                'Status: ${task.status}',
                                style: TextStyle(
                                  color: isCompleted ? Colors.green : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (isCompleted)
                                const Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
