import 'package:flutter_rivison_again/api/status_util.dart';

class ApiResponse {
  StatusUtil? statusUtil;
  dynamic data;
  String? errorMessage;
  String? role;
  ApiResponse({this.role,this.statusUtil, this.data, this.errorMessage});
}
