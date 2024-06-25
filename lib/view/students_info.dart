import 'package:flutter/material.dart';
import 'package:flutter_rivison_again/api/status_util.dart';
import 'package:flutter_rivison_again/provider/student_provider.dart';
import 'package:flutter_rivison_again/utils/helper.dart';
import 'package:flutter_rivison_again/view/signin_form.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentsInfo extends StatefulWidget {
  const StudentsInfo({super.key});

  @override
  State<StudentsInfo> createState() => _StudentsInfoState();
}

class _StudentsInfoState extends State<StudentsInfo> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getValue();
  }

  getValue() async {
    Future.delayed(
      Duration.zero,
      () async {
        var provider = Provider.of<StudentProvider>(context, listen: false);
        await provider.getStudent();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<StudentProvider>(
          builder: (context, studentProvider, child) =>
              studentProvider.getStudentStatus == StatusUtil.loading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              logoutUser();
                            },
                            child: Text("logout")),
                        Expanded(
                          child: ListView.builder(
                            itemCount: studentProvider.studentlist.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(studentProvider
                                            .studentlist[index].name!),
                                        Text(studentProvider
                                            .studentlist[index].password!),
                                      ],
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          await studentProvider.deleteStudent(
                                              studentProvider
                                                  .studentlist[index].id!);
                                          if (studentProvider
                                                  .getDeleteStudentStatus ==
                                              StatusUtil.success) {
                                            Helper.displaySnackbar(
                                                context, "data deleted");
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      StudentsInfo(),
                                                ),
                                                (route) => false);
                                          } else if (studentProvider
                                                  .getDeleteStudentStatus ==
                                              StatusUtil.error) {
                                            Helper.displaySnackbar(
                                                context, "deletion failed");
                                          }

                                          // createShowDialog(
                                          //     context,
                                          //     studentProvider
                                          //         .studentlist[index].id
                                          //         .toString(),
                                          //     studentProvider);
                                        },
                                        icon: Icon(Icons.delete))
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
        ),
      ),
    );
  }

  logoutUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLogin');
    Helper.displaySnackbar(context, "Successfully Logged Out!");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => SignInForm(),
        ),
        (route) => false);
  }

  createShowDialog(
      BuildContext context, String id, StudentProvider studentProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete '),
          content: Text('Are you sure you want to delete?'),
          actions: [
            TextButton(
              onPressed: () async {
                await studentProvider.deleteStudent(id);
                if (studentProvider.getDeleteStudentStatus ==
                    StatusUtil.success) {
                  Helper.displaySnackbar(context, "Data Successfully deleted");
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentsInfo(),
                      ),
                      (route) => false);
                } else if (studentProvider.getDeleteStudentStatus ==
                    StatusUtil.error) {
                  Helper.displaySnackbar(
                      context, "Error occured while deletion");
                }
                // Perform delete operation here
                // Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}
