import 'package:air_purifier/ui/shared/ui_helpers.dart';
import 'package:air_purifier/ui/widgets/busy_button.dart';
import 'package:air_purifier/ui/widgets/clipper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:stacked/stacked.dart';
import 'login_viewModel.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) {
        return Container(
          color: Color.fromRGBO(39, 35, 67, 1),
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              ClipPath(
                child: Container(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  color: Color.fromRGBO(186, 232, 232, 0.7),
                  height: height / 1.6,
                ),
                clipper: DownHillClipper(),
              ),
              ClipPath(
                child: Container(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  color: Color.fromRGBO(227, 246, 245, 0.7),
                  height: height / 1.5,
                ),
                clipper: UphillClipper(),
              ),
              Container(
                height: height,
                width: width,
                color: Colors.transparent,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        width / 10,
                        0.0,
                        0.0,
                        0.0,
                      ),
                      height: height / 2,
                      width: width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Hello",
                            style: TextStyle(
                              fontFamily: "Noah",
                              color: Colors.white,
                              fontSize: height / 15,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Text(
                            "Welcome to the Aeolus family.",
                            style: TextStyle(
                              fontFamily: "Noah",
                              fontSize: height / 50,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        0.0,
                        height / 12,
                        0.0,
                        0.0,
                      ),
                      height: height / 2,
                      width: width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Log In",
                            style: TextStyle(
                              fontFamily: "Noah",
                              color: Color.fromRGBO(39, 35, 67, 1),
                              fontSize: height / 20,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            height: height / 20,
                          ),
                          Container(
                            height: height / 15,
                            width: width / 1.5,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(39, 35, 67, 1),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: BusyButton(
                              title: "Enter Phone Number",
                              busy: model.isBusy,
                              onPressed: () => model.loginWithPhone(),
                              textStyle: TextStyle(
                                fontFamily: "Noah",
                                color: Colors.white,
                                fontSize: height / 43,
                                fontWeight: FontWeight.w300,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height / 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                color: Color.fromRGBO(39, 35, 67, 1),
                                height: 1,
                                width: width / 6,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "or",
                                style: TextStyle(
                                  color: Color.fromRGBO(39, 35, 67, 1),
                                  fontWeight: FontWeight.w100,
                                  fontSize: 11,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                color: Color.fromRGBO(39, 35, 67, 1),
                                height: 1,
                                width: width / 6,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height / 30,
                          ),
                          Container(
                            height: height / 15,
                            width: width / 1.5,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(39, 35, 67, 1),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: BusyButton(
                              title: "Continue with google",
                              onPressed: () => model.login(),
                              busy: model.isBusy,
                              textStyle: TextStyle(
                                fontFamily: "Noah",
                                color: Colors.white,
                                fontSize: height / 43,
                                fontWeight: FontWeight.w300,
                                decoration: TextDecoration.none,
                              ),
                              image: Image.asset(
                                "assets/google.png",
                                height: height / 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
