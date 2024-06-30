import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rivison_again/api/status_util.dart';
import 'package:flutter_rivison_again/custom/custom_button.dart';
import 'package:flutter_rivison_again/custom/custom_textformfield.dart';
import 'package:flutter_rivison_again/model/student.dart';
import 'package:flutter_rivison_again/provider/student_provider.dart';
import 'package:flutter_rivison_again/view/signin_form.dart';
import 'package:flutter_rivison_again/view/students_info.dart';
import 'package:flutter_rivison_again/utils/color%20_const.dart';
import 'package:flutter_rivison_again/utils/helper.dart';
import 'package:flutter_rivison_again/utils/string_const.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatefulWidget {
  SignUpForm({super.key, this.student});
  Student? student;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  @override
  void initState() {
    if (widget.student != null) {
      var provider = Provider.of<StudentProvider>(context, listen: false);
      provider.setName(widget.student!.name ?? "");
      provider.setPassword(widget.student!.password ?? "");
      provider.setGender(widget.student!.gender ?? "");
      provider.setContact(widget.student!.contact.toString());
      provider.setConfirmPassword(widget.student!.confirmPassword ?? "");
      provider.setAddress(widget.student!.address ?? "");
      provider.setRole(widget.student!.role ?? "");
      provider.setId(widget.student!.id ?? "");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    List<String> genderList = ["Male", "Female", "Others"];
    return Consumer<StudentProvider>(
      builder: (context, studentProvider, child) => SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      signupBannerStr,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextFormField(
                      initialValue: studentProvider.name,
                      onChanged: (value) {
                        studentProvider.setName(value);
                      },
                      labelText: nameStr,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return nameValidationStr;
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextFormField(
                      initialValue: studentProvider.address,
                      onChanged: (value) {
                        studentProvider.setAddress(value);
                      },
                      labelText: addresStr,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return addressValidationStr;
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    DropdownButtonFormField(
                      value: studentProvider.gender,
                      decoration: InputDecoration(
                          labelText: genderStr,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return genderValidationStr;
                        }
                        return null;
                      },
                      items: genderList
                          .map((gender) => DropdownMenuItem(
                                child: Text(gender),
                                value: gender,
                              ))
                          .toList(),
                      onChanged: (value) {
                        studentProvider.setGender(value!);
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextFormField(
                      initialValue: studentProvider.contact,
                      onChanged: (value) {
                        studentProvider.setContact(value);
                      },
                      inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      keyboardType: TextInputType.phone,
                      labelText: contactStr,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return contactValidationStr;
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    CustomTextFormField(
                      initialValue: studentProvider.password,
                      onChanged: (value) {
                        studentProvider.setPassword(value);
                      },
                      labelText: passwordStr,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return passwordValidationStr;
                        } else if (value.length < 8) {
                          return passworldLengthValidationStr;
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Visibility(
                      visible: false,
                      child: CustomTextFormField(
                        controller: studentProvider.setRole("user"),
                        labelText: "Role",
                      ),
                    ),
                    CustomTextFormField(
                      initialValue: studentProvider.confirmPassword,
                      onChanged: (value) {
                        studentProvider.setConfirmPassword(value);
                      },
                      labelText: confirmPasswordStr,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return passwordValidationStr;
                        } else if (value.length < 8) {
                          return passworldLengthValidationStr;
                        } else if (studentProvider.password != value) {
                          return passwordMatchValidationStr;
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    CustomButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (widget.student?.id != null) {
                            await studentProvider.updateStudentData();
                            if (studentProvider.getUpdateStudentStatus ==
                                StatusUtil.success) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignInForm(),
                                  ),
                                  (route) => false);
                              Helper.displaySnackbar(
                                  context, dataUpdatedSuccessfulStr);
                            } else if (studentProvider.getUpdateStudentStatus ==
                                StatusUtil.error) {
                              Helper.displaySnackbar(
                                  context, dataUpdateFailedStr);
                            }
                          } else {
                            await studentProvider.checkUserExistsOnSignup();
                            if (studentProvider.isUserExistOnSignUpStatus) {
                              Helper.displaySnackbar(
                                  context, "User already exists");
                            } else {
                              await studentProvider.saveStudent();
                              if (studentProvider.saveStudentStatus ==
                                  StatusUtil.success) {
                                await Helper.displaySnackbar(
                                    context, dataSavedSuccessfulStr);
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignInForm(),
                                    ),
                                    (route) => false);
                              } else if (studentProvider.saveStudentStatus ==
                                  StatusUtil.error) {
                                await Helper.displaySnackbar(
                                    context, studentProvider.errorMessage!);
                              }
                            }
                          }
                        }
                      },
                      backgroundColor: buttonBackgroundClr,
                      foregroundColor: buttonForegroundClr,
                      child: (studentProvider.saveStudentStatus ==
                                  StatusUtil.loading ||
                              studentProvider.getUpdateStudentStatus ==
                                  StatusUtil.loading)
                          ? CircularProgressIndicator()
                          : Text(
                              buttonStr,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                    ),
                    CustomButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInForm(),
                            ),
                            (route) => false);
                      },
                      child: Text("signin"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
