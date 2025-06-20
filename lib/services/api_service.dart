import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:worker_task/models/worker.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2/wtms_backend";

  /// Login worker with email and password
  static Future<Worker?> loginWorker({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login.php');
    try {
      final response = await http.post(url, body: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        if (result != null && result['status'] == 'success') {
          final userData = result['data'];
          return Worker.fromJson(userData);
        } else {
          print('Login failed: ${result['message']}');
        }
      } else {
        print('Login failed: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Login failed: $e');
    }
    return null;
  }

  /// Register new worker
  static Future<bool> registerWorker({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/register.php');
    try {
      final response = await http.post(url, body: {
        'name': name,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return true;
        } else {
          print('Registration failed: ${data['error']}');
        }
      } else {
        print('Registration failed: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Registration failed: $e');
    }
    return false;
  }

  /// Fetch worker profile by ID
  static Future<Map<String, dynamic>?> getProfile(String workerId) async {
    final url = Uri.parse('$baseUrl/get_profile.php');
    try {
      final response = await http.post(url, body: {'id': workerId});
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Get profile failed: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Get profile failed: $e');
    }
    return null;
  }

  /// Update worker profile
  static Future<bool> updateProfile({
    required String workerId,
    required String name,
    required String email,
    required String phone,
  }) async {
    final url = Uri.parse('$baseUrl/update_profile.php');
    try {
      final response = await http.post(url, body: {
        'worker_id': workerId,
        'name': name,
        'email': email,
        'phone': phone,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return true;
        } else {
          print('Update profile failed: ${data['error']}');
        }
      } else {
        print('Update profile failed: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Update profile failed: $e');
    }
    return false;
  }

  /// Fetch submissions for worker
  static Future<List<Map<String, dynamic>>> getSubmissions(String workerId) async {
    final url = Uri.parse('$baseUrl/get_submission.php');
    try {
      final response = await http.post(url, body: {'worker_id': workerId});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        } else {
          print('Fetch submissions failed: Unexpected data format');
        }
      } else {
        print('Fetch submissions failed: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Fetch submissions failed: $e');
    }
    return [];
  }

  /// Edit a submission 
  static Future<bool> editSubmission({
  required int submissionId,
  required String updatedText,
}) async {
  final url = Uri.parse('$baseUrl/edit_submission.php');
  try {
    final response = await http.post(url, body: {
      'submission_id': submissionId.toString(),
      'updated_text': updatedText,
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        return true;
      } else {
        print('Edit submission failed: ${data['error']}');
        throw Exception(data['error'] ?? 'Unknown error');
      }
    } else {
      print('Edit submission failed: Status code ${response.statusCode}');
      throw Exception('HTTP error ${response.statusCode}');
    }
  } catch (e) {
    print('Edit submission failed: $e');
    throw Exception(e.toString());
  }
}

}
