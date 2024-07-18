import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rivison_again/custom/custom_button.dart';
import 'package:flutter_rivison_again/custom/custom_textformfield.dart';
import 'package:flutter_rivison_again/utils/color%20_const.dart';
import 'package:flutter_rivison_again/view/otp_verification.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  String? phoneNumber;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text(
              "Forgot password",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.95,
              child: CustomTextFormField(
                onChanged: (value) {
                  phoneNumber = value;
                },
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
                keyboardType: TextInputType.phone,
                labelText: "Enter your phone number",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CustomButton(
              backgroundColor: buttonBackgroundClr,
              foregroundColor: buttonForegroundClr,
              onPressed: () async {
                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: '+977$phoneNumber',
                  verificationCompleted: (PhoneAuthCredential credential) {},
                  verificationFailed: (FirebaseAuthException e) {},
                  codeSent: (String verificationId, int? resendToken) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OtpVerification(verificationId: verificationId,),
                        ));
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {},
                );
              },
              child: Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}
