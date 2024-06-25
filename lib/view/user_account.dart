import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rivison_again/provider/student_provider.dart';
import 'package:flutter_rivison_again/utils/helper.dart';
import 'package:flutter_rivison_again/view/signin_form.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({super.key});

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (context, studentProvider, child) => SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              Row(
                children: [
                  Text("This is "),
                  // if (studentProvider.studentData!.role! == "user")
                  //   Text(studentProvider.studentData!.name!)
                  // else if (studentProvider.studentData!.role! == "admin")
                  //   Text(studentProvider.studentData!.name!)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}
