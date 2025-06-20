class Tasks{
  final int id;
  final String title;
  final String description;
  final String dateAssigned;
  final String dueDate;
  final String status;

  Tasks({
    required this.id,
    required this.title,
    this.description = '',
    this.dateAssigned = '',
    this.dueDate = '',
    required this.status,
  });

  factory Tasks.fromJson(Map<String, dynamic> json) {
    return Tasks(
      id: int.parse(json['work_ID'].toString()),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dateAssigned: json['date_assigned'] ?? '',
      dueDate: json['due_date'] ?? '',
      status: json['status'] ?? '',
    );
  }
}