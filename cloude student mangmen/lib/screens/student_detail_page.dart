import 'package:flutter/material.dart';

import '../models/student.dart';
import '../services/student_service.dart';

class StudentDetailPage extends StatefulWidget {
  final Student student;

  const StudentDetailPage({
    super.key,
    required this.student,
  });

  @override
  State<StudentDetailPage> createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController courseController;
  late TextEditingController semesterController;

  final StudentService service = StudentService();

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.student.name);
    emailController = TextEditingController(text: widget.student.email);
    phoneController = TextEditingController(text: widget.student.phone);
    courseController = TextEditingController(text: widget.student.course);
    semesterController = TextEditingController(text: widget.student.semester);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    courseController.dispose();
    semesterController.dispose();
    super.dispose();
  }

  void updateStudent() async {
    Student student = Student(
      id: widget.student.id,
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      course: courseController.text.trim(),
      semester: semesterController.text.trim(),
    );

    await service.updateStudent(student);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student updated'),
        ),
      );
    }
  }

  void deleteStudent() async {
    await service.deleteStudent(widget.student.id);

    if (mounted) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student deleted'),
        ),
      );
    }
  }

  Widget input(
    TextEditingController controller,
    String label,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            input(nameController, 'Student Name'),
            input(emailController, 'Email'),
            input(phoneController, 'Phone'),
            input(courseController, 'Course'),
            input(semesterController, 'Semester'),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: updateStudent,
                child: const Text('Update Student'),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: deleteStudent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete Student'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
