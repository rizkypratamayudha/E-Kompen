// lib/Model/semester_model.dart
class Semester {
  final int semesterId;
  final int userId;
  final String semester;

  Semester({
    required this.semesterId,
    required this.userId,
    required this.semester,
  });

  factory Semester.fromJson(Map<String, dynamic> json) {
    return Semester(
      semesterId: json['semester_id'],
      userId: json['user_id'],
      semester: json['semester'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'semester_id': semesterId,
      'user_id': userId,
      'semester': semester,
    };
  }
}
