import 'dart:ui';
import 'package:air_purifier/ui/shared/ui_helpers.dart';
import 'package:air_purifier/ui/views/phoneAuth/phone_auth_viewModel.dart';
import 'package:air_purifier/ui/widgets/busy_button.dart';
import 'package:air_purifier/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stacked/stacked.dart';

class PhoneAuthView extends StatelessWidget {
  PhoneAuthView({Key key, this.phoneNo}) : super(key: key);
  final String phoneNo;
  String otp = "";
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<PhoneAuthViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(phoneNo),
      builder: (context, model, child) => Scaffold(
          backgroundColor: Color.fromRGBO(39, 35, 67, 1),
          body: KeyboardDismisser(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              height: height,
              width: width,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: height / 6,
                    ),
                    Container(
                      padding:
                          EdgeInsets.fromLTRB(0, height / 5, 0, height / 10),
                      height: height / 8,
                      width: width / 7,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/otp.png",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height / 18,
                    ),
                    Text(
                      "Please enter the OTP",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: height / 32,
                        fontFamily: 'Noah',
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: height / 70,
                    ),
                    Text(
                      "We have sent you an access code via SMS \n on your mobile number.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: height / 50,
                        fontFamily: 'Noah',
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(
                      height: height / 15,
                    ),
                    PinCodeTextField(
                      showCursor: true,
                      keyboardType: TextInputType.number,
                      length: 6,
                      obscureText: false,
                      cursorColor: Color.fromRGBO(39, 35, 67, 1),
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.circle,
                        activeFillColor: HexColor("ffffff"),
                        selectedFillColor: HexColor("ffffff"),
                        inactiveColor: Colors.white,
                        activeColor: Colors.white,
                        selectedColor: Colors.white,
                        inactiveFillColor: Color.fromRGBO(39, 35, 67, 1),
                      ),
                      animationDuration: Duration(milliseconds: 300),
                      backgroundColor: Color.fromRGBO(39, 35, 67, 1),
                      enableActiveFill: true,
                      onCompleted: (v) {
                        otp = v.toString();
                        print("Completed");
                      },
                      onChanged: (value) {
                        print(value);
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        return true;
                      },
                      appContext: context,
                    ),
                    SizedBox(
                      height: height / 8,
                    ),
                    Container(
                      height: width / 6,
                      width: width / 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: IconButton(
                          icon: Icon(
                            Icons.arrow_forward_rounded,
                            color: Color.fromRGBO(39, 35, 67, 1),
                            size: height / 23,
                          ),
                          onPressed: () {
                            model.verifyOtp(otp);
                          }),
                    ),
                    SizedBox(
                      height: height / 20,
                    ),
                    GestureDetector(
                      child: Text(
                        "Resend OTP?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w100,
                          fontSize: height / 50,
                          fontFamily: 'Noah',
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        model.signIn();
                      },
                    ),
                  ],
                ),
              ),
            ),
          )),
      viewModelBuilder: () => PhoneAuthViewModel(),
    );
  }
}
