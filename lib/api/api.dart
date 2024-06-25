import 'package:dio/dio.dart';
import 'package:flutter_rivison_again/api/api_response.dart';
import 'package:flutter_rivison_again/api/status_util.dart';
import 'package:flutter_rivison_again/utils/helper.dart';
import 'package:flutter_rivison_again/utils/string_const.dart';

class Api {
  Dio dio = Dio();

  postApi(String url, var data) async {
    Response response = await dio.post(url, data: data);
    if (await Helper.isInternetConnectionAvailable()) {
      try {
        if (response.statusCode == 200 || response.statusCode == 201) {
          return ApiResponse(
              statusUtil: StatusUtil.success, data: response.data);
        }
      } catch (e) {
        return ApiResponse(
            statusUtil: StatusUtil.error, errorMessage: e.toString());
      }
    } else {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: noInternetConnectionStr);
    }
  }

  getApi(String url) async {
    Response response = await dio.get(url);
    if (await Helper.isInternetConnectionAvailable()) {
      try {
        if (response.statusCode == 200 || response.statusCode == 201) {
          return ApiResponse(
              statusUtil: StatusUtil.success, data: response.data);
        }
      } catch (e) {
        return ApiResponse(
            statusUtil: StatusUtil.error, errorMessage: e.toString());
      }
    } else {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: noInternetConnectionStr);
    }
  }
}
