class UserProfile {
  final String email;
  final String department;
  final String grade;
  final String birthYear;
  final String gender;
  final String userId;

  const UserProfile({
    required this.email,
    required this.department,
    required this.grade,
    required this.birthYear,
    required this.gender,
    required this.userId,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      email: json['email'] ?? '',
      department: json['department'] ?? '',
      grade: json['grade'] ?? '',
      birthYear: json['birthYear'] ?? '',
      gender: json['gender'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'department': department,
    'grade': grade,
    'birthYear': birthYear,
    'gender': gender,
    'userId': userId,
  };

  // ✅ 新增 copyWith 方法
  UserProfile copyWith({
    String? email,
    String? department,
    String? grade,
    String? birthYear,
    String? gender,
    String? userId,
  }) {
    return UserProfile(
      email: email ?? this.email,
      department: department ?? this.department,
      grade: grade ?? this.grade,
      birthYear: birthYear ?? this.birthYear,
      gender: gender ?? this.gender,
      userId: userId ?? this.userId,
    );
  }
}
