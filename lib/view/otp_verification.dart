import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_rivison_again/custom/custom_button.dart';
import 'package:flutter_rivison_again/utils/color%20_const.dart';
import 'package:flutter_rivison_again/utils/helper.dart';
import 'package:flutter_rivison_again/view/forgot_password.dart';

class OtpVerification extends StatelessWidget {
  String? verificationId;
  String smsCode = "";
  FirebaseAuth auth = FirebaseAuth.instance;

  OtpVerification({super.key, this.verificationId});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPassword(),
                          ),
                          (route) => false);
                    },
                    icon: Icon(Icons.arrow_back_ios)),
                Text(
                  "OTP Verification",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            OtpTextField(
              numberOfFields: 6,
              borderColor: Color(0xFF512DA8),
              //set to true to show as box or false to show as dash
              showFieldAsBox: true,
              //runs when a code is typed in
              onCodeChanged: (String code) {
                smsCode = smsCode + code;
                //handle validation or checks here
              },
              //runs when every textfield is filled
              onSubmit: (String verificationCode) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Verification Code"),
                        content: Text('Code entered is $verificationCode'),
                      );
                    });
              }, // end onSubmit
            ),
            SizedBox(
              height: 40,
            ),
            CustomButton(
              backgroundColor: buttonBackgroundClr,
              foregroundColor: buttonForegroundClr,
              onPressed: () async {
                try {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: verificationId!, smsCode: smsCode!);

                  // Sign the user in (or link) with the credential
                  await auth.signInWithCredential(credential);
                  Helper.displaySnackbar(context, "Success.");
                } catch (e) {
                  Helper.displaySnackbar(context, "Failed.");
                }
              },
              child: Text("Proceed"),
            )
          ],
        ),
      ),
    );
  }
}
