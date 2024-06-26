import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rivison_again/firebase_opt\ions.dart';
import 'package:flutter_rivison_again/utils/string_const.dart';
import 'package:flutter_rivison_again/view/home.dart';
import 'package:flutter_rivison_again/provider/student_provider.dart';
import 'package:flutter_rivison_again/view/signin_form.dart';
import 'package:flutter_rivison_again/view/signup_form.dart';
import 'package:flutter_rivison_again/view/students_info.dart';
import 'package:flutter_rivison_again/view/bottom_navbar.dart';
import 'package:flutter_rivison_again/view/user_account.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isUserLoggedIn = false;
  @override
  void initState() {
    // TODO: implement initState
    readValueFromSharedPreference();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => StudentProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: isUserLoggedIn ? StudentsInfo() : StudentsInfo(),
      ),
    );
  }

  readValueFromSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isUserLoggedIn = prefs.getBool('isLogin') ?? false;
    setState(() {
      isUserLoggedIn;
    });
  }
}
