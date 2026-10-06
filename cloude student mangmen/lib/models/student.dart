class Student {
  String id;
  String name;
  String email;
  String phone;
  String course;
  String semester;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.course,
    required this.semester,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'course': course,
      'semester': semester,
    };
  }

  factory Student.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return Student(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      course: map['course'] ?? '',
      semester: map['semester'] ?? '',
    );
  }
}
