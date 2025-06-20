import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubmissionScreen extends StatefulWidget {
  final int workId;
  final int workerId;
  final String taskTitle;

  const SubmissionScreen({
    super.key,
    required this.workId,
    required this.workerId,
    required this.taskTitle,
  });

  @override
  State<SubmissionScreen> createState() => _SubmissionScreenState();
}

class _SubmissionScreenState extends State<SubmissionScreen> {
  final _controller = TextEditingController();
  bool _isSubmitting = false;
  String _message = '';

  Future<void> _submitWork() async {
    final submissionText = _controller.text.trim();
    if (submissionText.isEmpty) {
      setState(() => _message = 'Please describe what you completed.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _message = '';
    });

    final uri = Uri.parse('http://10.0.2.2/wtms_backend/submit_task.php');
    final response = await http.post(uri, body: {
      'work_id': widget.workId.toString(),
      'worker_id': widget.workerId.toString(),
      'submission_text': submissionText,
    });

    setState(() => _isSubmitting = false);

    if (response.statusCode == 200 && response.body.contains('success')) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true); // Go back and refresh TasksScreen
    } else {
      setState(() => _message = 'Submission failed. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Task:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.taskTitle, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'What did you complete?',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitWork,
              child: Text(_isSubmitting ? 'Submitting...' : 'Submit'),
            ),
            if (_message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_message, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
