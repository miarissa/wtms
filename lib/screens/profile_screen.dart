import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  final String workerId;
  const ProfileScreen({super.key, required this.workerId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  File? _imageFile;
  bool _isLoading = true;
  String _message = '';
  String _profilePicURL = '';

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/wtms_backend/get_profile.php'),
      body: {'id': widget.workerId},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _nameController.text = data['full_name'] ?? '';
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _addressController.text = data['address'] ?? '';
        _profilePicURL = data['profile_pic'] != null && data['profile_pic'] != ''
            ? 'http://10.0.2.2/wtms_backend/uploads/${data['profile_pic']}'
            : '';
        _isLoading = false;
      });
    } else {
      setState(() {
        _message = 'Failed to load profile';
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _profilePicURL = '';
      });
    }
  }

  Future<void> _removeImage() async {
    setState(() {
      _imageFile = null;
      _profilePicURL = '';
    });
  }

  Future<void> _updateProfile() async {
    setState(() => _message = '');
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2/wtms_backend/update_profile.php'),
    );
    request.fields['id'] = widget.workerId;
    request.fields['full_name'] = _nameController.text;
    request.fields['email'] = _emailController.text;
    request.fields['phone'] = _phoneController.text;
    request.fields['address'] = _addressController.text;

    if (_imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'profile_pic', _imageFile!.path));
    }

    final response = await request.send();
    final resBody = await response.stream.bytesToString();
    if (response.statusCode == 200 && resBody.contains('success')) {
      setState(() => _message = 'Profile updated successfully.');
      _fetchProfile();
    } else {
      setState(() => _message = 'Update failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text('My Profile'),
),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : (_profilePicURL != ''
                                  ? NetworkImage(_profilePicURL)
                                  : null) as ImageProvider?,
                          child: (_imageFile == null && _profilePicURL == '')
                              ? const Icon(Icons.camera_alt, size: 40)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: _removeImage,
                        icon: const Icon(Icons.delete),
                        label: const Text('Remove Picture'),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _nameController,
                        decoration:
                            const InputDecoration(labelText: 'Full Name'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _phoneController,
                        decoration: const InputDecoration(labelText: 'Phone'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _addressController,
                        decoration: const InputDecoration(labelText: 'Address'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _updateProfile,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Save Changes'),
                      ),
                      if (_message.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(_message,
                              style: const TextStyle(color: Colors.red)),
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
