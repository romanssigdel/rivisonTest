import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rivison_again/api/status_util.dart';
import 'package:flutter_rivison_again/model/student.dart';
import 'package:flutter_rivison_again/provider/student_provider.dart';
import 'package:flutter_rivison_again/utils/helper.dart';
import 'package:flutter_rivison_again/view/signin_form.dart';
import 'package:flutter_rivison_again/view/signup_form.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
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

  File file = File("");
  bool loader = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<StudentProvider>(
          builder: (context, studentProvider, child) => studentProvider
                      .getStudentStatus ==
                  StatusUtil.loading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    file.path.isEmpty
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTL2T2DS2XGxbYwc3F9t6zxhvzNL1noALlQYvAyvFBb0J8TD1z8_8Tegd8iYnyT8rI3kXzP5Mzm9cWB_HRtb42U1w4h3HlmXxrrRC-a4r4"),
                          )
                        : CircleAvatar(backgroundImage: FileImage(file)),
                    ElevatedButton(
                        onPressed: () {
                          pickImage();
                        },
                        child: loader == true
                            ? CircularProgressIndicator()
                            : Text("Upload Image.")),
                    ElevatedButton(
                        onPressed: () {
                          googleSignOut();
                        },
                        child: Text("Google Signout")),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      createShowDialog(
                                          context,
                                          studentProvider.studentlist[index].id
                                              .toString(),
                                          studentProvider);
                                    },
                                    icon: Icon(Icons.delete)),
                                IconButton(
                                    onPressed: () {
                                      editShowDialog(context,
                                          studentProvider.studentlist[index]);
                                    },
                                    icon: Icon(Icons.edit))
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

  editShowDialog(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit'),
          content: Text('Are you sure you want to edit?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpForm(
                        student: student,
                      ),
                    ),
                    (route) => false);

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
  // import 'package:flutter/foundation.dart' show kIsWeb;

  googleSignOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
      Helper.displaySnackbar(context, "Google Signout Successful");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => SignInForm(),
          ),
          (route) => false);
    } catch (e) {
      Helper.displaySnackbar(context, "Google Signout UnSuccessful");
    }
  }

  pickImage() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    file = File(image!.path);
    setState(() {
      loader = true;
      file;
    });
    try {
      // List<String> fileName = file.path.split('/');
      String fileName = file.path.split('/').last;
      var storageReference = FirebaseStorage.instance.ref();
      var uploadReference = storageReference.child(fileName);
      await uploadReference.putFile(file);
      String? downloadUrl = await uploadReference.getDownloadURL();
      setState(() {
        loader = false;
      });
      print("downloadUrl$downloadUrl");
    } catch (e) {
      setState(() {
        loader = false;
      });
    }
  }
}
