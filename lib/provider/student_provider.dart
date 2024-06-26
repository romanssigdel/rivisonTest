import 'package:flutter/material.dart';
import 'package:flutter_rivison_again/api/api_response.dart';
import 'package:flutter_rivison_again/api/status_util.dart';
import 'package:flutter_rivison_again/model/student.dart';
import 'package:flutter_rivison_again/services/student_services.dart';
import 'package:flutter_rivison_again/services/student_services_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentProvider extends ChangeNotifier {
  String? name, address, contact, gender, password, confirmPassword;
  TextEditingController? roleTextField;
  String? errorMessage;
  bool isUserCheckStatus = false;
  Student? studentData;
  bool check = false;
  String? studentId;

  TextEditingController nameTextField = TextEditingController();
  TextEditingController passwordTextField = TextEditingController();

  setRole(value) {
    roleTextField = TextEditingController(text: value);
  }

  setBoolCheck(value) {
    check = value;
    notifyListeners();
  }

  setName(String value) {
    name = value;
    notifyListeners();
  }

  // setRole(String value) {
  //   role = value;
  // }

  setAddress(String value) {
    address = value;
  }

  setContact(String value) {
    contact = value;
  }

  setPassword(String value) {
    password = value;
    notifyListeners();
  }

  setConfirmPassword(String value) {
    confirmPassword = value;
  }

  setGender(String value) {
    gender = value;
  }

  List<Student> studentlist = [];

  StatusUtil _saveStudentStaus = StatusUtil.none;
  StatusUtil get saveStudentStatus => _saveStudentStaus;

  StatusUtil _getStudentStatus = StatusUtil.none;
  StatusUtil get getStudentStatus => _getStudentStatus;

  StatusUtil _getLoginStudentStatus = StatusUtil.none;
  StatusUtil get getLoginStudentStatus => _getLoginStudentStatus;

  StatusUtil _getDeleteStudentStatus = StatusUtil.none;
  StatusUtil get getDeleteStudentStatus => _getDeleteStudentStatus;
  StudentServices studentServices = StudentServicesImpl();

  setSaveStudentStatus(StatusUtil status) {
    _saveStudentStaus = status;
    notifyListeners();
  }

  setGetStudentStatus(StatusUtil status) {
    _getStudentStatus = status;
    notifyListeners();
  }

  setGetLoginStudentStatus(StatusUtil status) {
    _getLoginStudentStatus = status;
    notifyListeners();
  }

  setGetDeleteStudentStatus(StatusUtil status) {
    _getDeleteStudentStatus = status;
    notifyListeners();
  }

  Future<void> saveStudent() async {
    if (_saveStudentStaus != StatusUtil.loading) {
      setSaveStudentStatus(StatusUtil.loading);
    }
    Student student = Student(
        name: name,
        address: address,
        role: roleTextField!.text,
        contact: int.parse(contact!),
        gender: gender,
        password: password,
        confirmPassword: confirmPassword);

    ApiResponse apiResponse = await studentServices.saveStudent(student);

    if (apiResponse.statusUtil == StatusUtil.success) {
      setSaveStudentStatus(StatusUtil.success);
      //await studentServices.getStudent();
    } else if (apiResponse.statusUtil == StatusUtil.error) {
      errorMessage = apiResponse.errorMessage;
      setSaveStudentStatus(StatusUtil.error);
    }
  }

  Future<void> getStudent() async {
    if (_getStudentStatus != StatusUtil.loading) {
      setGetStudentStatus(StatusUtil.loading);
    }
    ApiResponse apiResponse = await studentServices.getStudent();

    if (apiResponse.statusUtil == StatusUtil.success) {
      studentlist = apiResponse.data;
      setGetStudentStatus(StatusUtil.success);
    } else if (apiResponse.statusUtil == StatusUtil.error) {
      errorMessage = apiResponse.errorMessage;
      setGetStudentStatus(StatusUtil.error);
    }
  }

  Future<void> loginStudent() async {
    if (_getLoginStudentStatus != StatusUtil.loading) {
      setGetLoginStudentStatus(StatusUtil.loading);
    }
    Student student = Student(name: name, password: password);
    ApiResponse apiResponse = await studentServices.checkUserData(student);
    if (apiResponse.statusUtil == StatusUtil.success) {
      // studentData = apiResponse.data;
      isUserCheckStatus = apiResponse.data;
      setGetLoginStudentStatus(StatusUtil.success);
    } else if (apiResponse.statusUtil == StatusUtil.error) {
      errorMessage = apiResponse.errorMessage;
      setGetLoginStudentStatus(StatusUtil.error);
    }
  }

  Future<void> deleteStudent(String id) async {
    if (_getDeleteStudentStatus != StatusUtil.loading) {
      setGetDeleteStudentStatus(StatusUtil.loading);
    }

    ApiResponse apiResponse = await studentServices.deleteUserData(id);
    if (apiResponse.statusUtil == StatusUtil.success) {
      setGetDeleteStudentStatus(StatusUtil.success);
    } else if (apiResponse.statusUtil == StatusUtil.error) {
      errorMessage = apiResponse.errorMessage;
      setGetDeleteStudentStatus(StatusUtil.error);
    }
  }

  saveValueToSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', true);
  }

  rememberMe(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      await prefs.setBool('rememberMe', true);
      await prefs.setString("name", nameTextField.text);
      await prefs.setString("password", passwordTextField.text);
    } else {
      await prefs.remove("rememberMe");
      await prefs.remove("name");
      await prefs.remove("password");
    }
  }

  readRememberMe() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    nameTextField.text = prefs.getString("name") ?? "";
    passwordTextField.text = prefs.getString("password") ?? "";
    notifyListeners();
  }
}
