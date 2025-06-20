import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditSubmission extends StatefulWidget {
  final int submissionId;
  final String initialText;

  const EditSubmission({
    super.key,
    required this.submissionId,
    required this.initialText,
  });

  @override
  State<EditSubmission> createState() => _EditSubmissionState();
}

class _EditSubmissionState extends State<EditSubmission> {
  late TextEditingController _textController;
  bool _canEdit = false;
  double _hoursElapsed = 0.0;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText);
    _fetchSubmissionDetail();
  }

  Future<void> _fetchSubmissionDetail() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/wtms_backend/get_submissionDetail.php'),
        body: {'submission_id': widget.submissionId.toString()},
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded is Map && decoded['success'] == true) {
          setState(() {
            _textController.text = decoded['text'] ?? '';
            _canEdit = decoded['can_edit'] == true;
            _hoursElapsed = (decoded['hours_elapsed'] as num).toDouble();
            _isLoading = false;
          });
        } else if (decoded is Map && decoded['success'] == false) {
          throw Exception(decoded['message']);
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to load submission detail');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSubmission() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/wtms_backend/edit_submission.php'),
        body: {
          'submission_id': widget.submissionId.toString(),
          'updated_text': _textController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded is Map && decoded['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Submission updated successfully!')),
          );
          Navigator.pop(context, true); //return success
        } else {
          throw Exception(decoded['error'] ?? 'Unknown error');
        }
      } else {
        throw Exception('Failed to save submission');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Submission')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Editable: $_canEdit  (Submitted $_hoursElapsed hours ago)',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _textController,
                        maxLines: 10,
                        readOnly: !_canEdit,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Submission Text',
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _canEdit ? _saveSubmission : null,
                        child: const Text('Save Changes'),
                      ),
                    ],
                  ),
                ),
    );
  }
}
