import 'package:air_purifier/ui/shared/ui_helpers.dart';
import 'package:air_purifier/ui/widgets/busy_button.dart';
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
        return SingleChildScrollView(
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  HexColor('#0CA9EC'),
                  HexColor('#7ED8FE'),
                  HexColor('#E0EEF4'),
                  Colors.white
                ],
                stops: [0.3, 0.6, 0.87, 1],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: Text(
                    "AEOLUS",
                    style: GoogleFonts.comicNeue(
                      textStyle: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                verticalSpaceMedium,
                Container(
                  child: Text(
                    "Air Purifier",
                    style: GoogleFonts.comicNeue(
                      textStyle: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height / 3,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    0.0,
                    0.0,
                    0.0,
                    height / 15,
                  ),
                  child: Container(
                    width: width / 1.6,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white,
                          HexColor('#0CA9EC'),
                        ],
                        stops: [0.87, 1],
                      ),
                    ),
                    child: BusyButton(
                      onPressed: () {
                        model.login();
                      },
                      title: "Continue with Google",
                      textStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w200,
                        decoration: TextDecoration.none,
                      ),
                      image: Image.asset(
                        'assets/google.png',
                        height: 30.0,
                        width: width / 20,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    0.0,
                    0.0,
                    0.0,
                    height / 10,
                  ),
                  child: Container(
                    width: width / 1.6,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white,
                          HexColor('#0CA9EC'),
                        ],
                        stops: [0.87, 1],
                      ),
                    ),
                    child: BusyButton(
                      onPressed: () {
                        model.loginWithPhone();
                      },
                      title: "Continue with Phone",
                      textStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w200,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
