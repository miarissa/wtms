class Submissions {
  final int id;
  final String taskTitle;
  final String text;
  final String date;
  final bool canEdit;
  final double hoursElapsed;

  Submissions({
    required this.id,
    required this.taskTitle,
    required this.text,
    required this.date,
    required this.canEdit,
    required this.hoursElapsed,
  });

  factory Submissions.fromJson(Map<String, dynamic> json) {
    return Submissions(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      taskTitle: json['task_title'] ?? '',
      text: json['submission_text'] ?? '',
      date: json['date'] ?? '',
      canEdit: json['can_edit'].toString() == 'true' || json['can_edit'] == true,
      hoursElapsed: (json['hours_elapsed'] is num)
          ? (json['hours_elapsed'] as num).toDouble()
          : double.tryParse(json['hours_elapsed'].toString()) ?? 0.0,
    );
  }
}
