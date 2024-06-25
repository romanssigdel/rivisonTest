import 'package:flutter/material.dart';
import 'package:flutter_rivison_again/api/status_util.dart';
import 'package:flutter_rivison_again/provider/student_provider.dart';
import 'package:flutter_rivison_again/view/signin_form.dart';
import 'package:flutter_rivison_again/utils/helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return Consumer<StudentProvider>(
      builder: (context, studentProvider, child) => SafeArea(
        child: Scaffold(
          body: studentProvider.getStudentStatus == StatusUtil.loading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                   
                    Expanded(
                      child: ListView.builder(
                        itemCount: studentProvider.studentlist.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Column(
                              children: [
                                Text(studentProvider.studentlist[index].name!)
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

 
}
