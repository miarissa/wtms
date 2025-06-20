class Worker {
  final String id;
  final String name;
  final String email;

  Worker({required this.id, required this.name, required this.email});

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['id'].toString(),
      name: json['full_name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': name,
      'email': email,
    };
  }
}

