import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rivison_again/api/api.dart';
import 'package:flutter_rivison_again/api/api_const.dart';
import 'package:flutter_rivison_again/api/api_response.dart';
import 'package:flutter_rivison_again/api/status_util.dart';
import 'package:flutter_rivison_again/model/student.dart';
import 'package:flutter_rivison_again/services/student_services.dart';

class StudentServicesImpl extends StudentServices {
  Api api = Api();
  List<Student> studentList = [];
  String? userRole;
  @override
  Future<ApiResponse> saveStudent(Student student) async {
    try {
      // bool isSuccess = false;
      await FirebaseFirestore.instance
          .collection("users")
          .add(student.toJson())
          .then((value) {
        // isSuccess = true;
      });
      return ApiResponse(
        statusUtil: StatusUtil.success,
      );
    } catch (e) {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: e.toString());
    }
  }

  @override
  Future<ApiResponse> getStudent() async {
    try {
      var value = await FirebaseFirestore.instance.collection("users").get();
      var studentList =
          value.docs.map((e) => Student.fromJson(e.data())).toList();
      for (int i = 0; i < studentList.length; i++) {
        studentList[i].id = value.docs[i].id;
      }
      return ApiResponse(statusUtil: StatusUtil.success, data: studentList);
    } catch (e) {
      return ApiResponse(statusUtil: StatusUtil.error);
    }
  }

  @override
  Future<ApiResponse> checkUserData(Student student) async {
    bool isUserExists = false;
    // Student? studentData;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .where("name", isEqualTo: student.name)
          .where("password", isEqualTo: student.password)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          //  studentData = Student.fromJson(value.docs[0].data());
          // print(studentData!.address);
          isUserExists = true;
          //print(value);
        }
      });
      return ApiResponse(statusUtil: StatusUtil.success, data: isUserExists);
    } catch (ex) {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: ex.toString());
    }
  }

  @override
  Future<ApiResponse> deleteUserData(String id) async {
    // TODO: implement deleteUserData
    try {
      await FirebaseFirestore.instance.collection("users").doc(id).delete();
      return ApiResponse(statusUtil: StatusUtil.success);
    } catch (e) {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: e.toString());
    }
  }

  @override
  Future<ApiResponse> updateUserData(Student student) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(student.id)
          .update(student.toJson());
      return ApiResponse(statusUtil: StatusUtil.success);
    } catch (e) {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: e.toString());
    }
  }
}
