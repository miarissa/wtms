import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:worker_task/models/submissions.dart';
import 'edit_submission.dart';

class SubmissionHistory extends StatefulWidget {
  final String workerId;
  const SubmissionHistory({super.key, required this.workerId});

  @override
  State<SubmissionHistory> createState() => _SubmissionHistoryState();
}

class _SubmissionHistoryState extends State<SubmissionHistory> {
  List<Submissions> _submissions = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchSubmissions();
  }

  Future<void> _fetchSubmissions() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/wtms_backend/get_submission.php'),
        body: {'worker_id': widget.workerId},
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded is List) {
          setState(() {
            _submissions = decoded.map((json) => Submissions.fromJson(json)).toList();
            _isLoading = false;
          });
        } else if (decoded is Map && decoded['success'] == false) {
          throw Exception(decoded['message']);
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to load submission history');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submission History')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ListView.builder(
                  itemCount: _submissions.length,
                  itemBuilder: (context, index) {
                    final sub = _submissions[index];
                    return InkWell(
                      onTap: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditSubmission(
                              submissionId: sub.id,
                              initialText: sub.text,
                            ),
                          ),
                        );
                        if (updated == true) _fetchSubmissions();
                      },
                      child: Card(
                        elevation: 6,
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Task: ${sub.taskTitle}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text("Date: ${sub.date}"),
                              Text("Summary: ${sub.text.length > 50 ? '${sub.text.substring(0, 50)}...' : sub.text}"),
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
