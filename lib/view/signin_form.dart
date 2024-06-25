import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rivison_again/api/status_util.dart';
import 'package:flutter_rivison_again/custom/custom_button.dart';
import 'package:flutter_rivison_again/custom/custom_textformfield.dart';
import 'package:flutter_rivison_again/view/home.dart';
import 'package:flutter_rivison_again/provider/student_provider.dart';
import 'package:flutter_rivison_again/view/signup_form.dart';
import 'package:flutter_rivison_again/view/students_info.dart';
import 'package:flutter_rivison_again/utils/color%20_const.dart';
import 'package:flutter_rivison_again/utils/helper.dart';
import 'package:flutter_rivison_again/utils/string_const.dart';
import 'package:flutter_rivison_again/view/user_account.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInForm extends StatefulWidget {
  SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      var provider = Provider.of<StudentProvider>(context, listen: false);

      provider.readRememberMe();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (context, studentProvider, child) => SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    signinBannerStr,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextFormField(
                    controller: studentProvider.nameTextField,
                    // initialValue:
                    // studentProvider.check ? studentProvider.name : "",
                    onChanged: (value) {
                      studentProvider.setName(value);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return nameValidationStr;
                      }
                      return null;
                    },
                    labelText: nameStr,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextFormField(
                    controller: studentProvider.passwordTextField,
                    // initialValue:
                    // studentProvider.check ? studentProvider.password : "",
                    onChanged: (value) {
                      studentProvider.setPassword(value);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return passwordValidationStr;
                      } else if (value.length < 8) {
                        return passworldLengthValidationStr;
                      }
                      return null;
                    },
                    labelText: passwordStr,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await studentProvider.loginStudent();
                        if (studentProvider.getLoginStudentStatus ==
                            StatusUtil.success) {
                          if (studentProvider.isUserCheckStatus) {
                            Helper.displaySnackbar(context, loginStr);
                            // studentProvider.saveValueToSharedPreference();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StudentsInfo(),
                                ),
                                (route) => false);
                          } else {
                            Helper.displaySnackbar(context, invalidCredential);
                          }
                        } else if (studentProvider.getLoginStudentStatus ==
                            StatusUtil.error) {
                          Helper.displaySnackbar(context, loginFailedStr);
                        }
                      }
                    },
                    backgroundColor: buttonBackgroundClr,
                    foregroundColor: buttonForegroundClr,
                    child: studentProvider.getLoginStudentStatus ==
                            StatusUtil.loading
                        ? CircularProgressIndicator()
                        : Text(
                            buttonStr,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: studentProvider.check,
                        onChanged: (value) {
                          studentProvider.rememberMe(value!);
                          studentProvider.setBoolCheck(value);
                        },
                      ),
                      Text(
                        rememberMe,
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  CustomButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpForm(),
                          ),
                          (route) => false);
                    },
                    child: Text("signup"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
