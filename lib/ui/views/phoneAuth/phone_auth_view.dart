import 'dart:ui';
import 'package:air_purifier/ui/shared/ui_helpers.dart';
import 'package:air_purifier/ui/views/phoneAuth/phone_auth_viewModel.dart';
import 'package:air_purifier/ui/widgets/busy_button.dart';
import 'package:air_purifier/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:stacked/stacked.dart';

class PhoneAuthView extends StatelessWidget {
  const PhoneAuthView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<PhoneAuthViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.white,
          body: KeyboardDismisser(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              color: Color.fromRGBO(36, 37, 41, 1),
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
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Container(
                          height: 130,
                          width: 130,
                        ),
                      ],
                    ),
                    verticalSpaceMedium,
                    Text(
                      "WELCOME",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 22.0,
                        color: HexColor("#3585FE"),
                      ),
                    ),
                    verticalSpaceSmall,
                    Text(
                      "Register to continue your Journey",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18.0,
                        color: HexColor("#3585FE"),
                      ),
                    ),
                    verticalSpaceLarge,
                    verticalSpaceMedium,
                    InputField(
                      placeholder: 'Enter Mobile Number',
                      // prefixText: "+91  ",
                      prefix: Container(
                        child: Text("+91 "),
                      ),
                      textInputType: TextInputType.number,
                      prefixIcon: Icon(Icons.person),
                      controller: model.phoneNoController,
                    ),
                    verticalSpaceSmall,
                    InputField(
                      placeholder: '               Enter OTP',
                      textInputType: TextInputType.number,
                      prefixIcon: Icon(Icons.messenger_outline_outlined),
                      controller: model.otpController,
                    ),
                    verticalSpaceMedium,
                    verticalSpaceLarge,
                    Container(
                      height: height / 16.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: HexColor("#3585FE"),
                      ),
                      child: BusyButton(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: (height / 18) * 0.4,
                        ),
                        title: model.isOtpSeen ? 'REGISTER' : 'SEND OTP',
                        busy: model.isBusy,
                        onPressed: () {
                          if (!model.isOtpSeen)
                            model.checkInputParams();
                          else {
                            model.verifyOtp();
                          }
                        },
                      ),
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
