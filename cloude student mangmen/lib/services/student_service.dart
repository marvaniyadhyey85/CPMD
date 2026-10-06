import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/student.dart';

class StudentService {
  final CollectionReference students =
      FirebaseFirestore.instance.collection('students');

  // CREATE
  Future<void> addStudent(Student student) async {
    await students.add(student.toMap());
  }

  // READ
  Stream<List<Student>> getStudents() {
    return students
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Student.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  // UPDATE
  Future<void> updateStudent(Student student) async {
    await students.doc(student.id).update(
          student.toMap(),
        );
  }

  // DELETE
  Future<void> deleteStudent(String id) async {
    await students.doc(id).delete();
  }

  // SEARCH
  Stream<List<Student>> searchStudents(String search) {
    return students
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      List<Student> list = [];

      for (var doc in snapshot.docs) {
        Student student = Student.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );

        if (student.name
                .toLowerCase()
                .contains(search.toLowerCase()) ||
            student.email
                .toLowerCase()
                .contains(search.toLowerCase()) ||
            student.course
                .toLowerCase()
                .contains(search.toLowerCase())) {
          list.add(student);
        }
      }

      return list;
    });
  }
}
