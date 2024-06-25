import 'package:flutter_rivison_again/api/api_response.dart';
import 'package:flutter_rivison_again/model/student.dart';

abstract class StudentServices {
  Future<ApiResponse> saveStudent(Student student);
  Future<ApiResponse> getStudent();
  Future<ApiResponse> checkUserData(Student student);
  Future<ApiResponse> deleteUserData(String id);
}
