import 'package:air_purifier/ui/shared/ui_helpers.dart';
import 'package:air_purifier/ui/widgets/busy_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:stacked/stacked.dart';

import 'home_viewModel.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) => model.getPermissions(),
      builder: (context, model, child) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: model.today.hour > 6 && model.today.hour < 19
                ? Colors.white
                : model.primaryColor,
            onPressed: () {
              model.gotoRemoteScreen();
            },
            child: Container(
              height: width / 12,
              width: width / 12,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      model.today.hour > 6 && model.today.hour < 19
                          ? "assets/remote_day.png"
                          : "assets/remote_night.png"),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          body: GestureDetector(
            onHorizontalDragEnd: (e) {
              if (e.primaryVelocity > 0) {
                model.drawerCurrentState = FSBStatus.FSB_OPEN;
                model.notifyListeners();
              } else {
                model.drawerCurrentState = FSBStatus.FSB_CLOSE;
                model.notifyListeners();
              }
            },
            child: FoldableSidebarBuilder(
              drawerBackgroundColor: Colors.white,
              drawer: Container(
                width: width * 0.60,
                height: height,
                color: model.primaryColor,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: height / 20,
                      ),
                      child: Container(
                        width: width * 0.3,
                        height: width * 0.3,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/splash.png",
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        // Go to Bluetooth
                        model.goToBluetoothScreen();
                      },
                      horizontalTitleGap: 0.0,
                      leading: Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Reconfigure Device",
                        style: TextStyle(
                          fontSize: height / 45,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        model.logout();
                      },
                      horizontalTitleGap: 0.0,
                      leading: Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Log Out",
                        style: TextStyle(
                          fontSize: height / 45,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              status: model.drawerCurrentState,
              screenContents: SafeArea(
                child: Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    ///Background Image
                    FadeInImage(
                      height: height,
                      width: width,
                      fadeInDuration: Duration(milliseconds: 300),
                      image: AssetImage(
                        model.today.hour > 6 && model.today.hour < 19
                            ? "assets/day.png"
                            : "assets/night.png",
                      ),
                      fit: BoxFit.fitHeight,
                      placeholder: AssetImage("assets/placeholder.png"),
                    ),

                    ///Data
                    model.temperature != null
                        ? Container(
                            height: height,
                            width: width,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ///Temp
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    model.today.hour > 6 &&
                                            model.today.hour < 19
                                        ? width / 1.6
                                        : 0.0,
                                    height / 20,
                                    model.today.hour > 6 &&
                                            model.today.hour < 19
                                        ? 0.0
                                        : width / 1.6,
                                    0.0,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${model.description ?? ""}',
                                        style: TextStyle(
                                          fontSize: height / 40,
                                          color: model.today.hour > 6 &&
                                                  model.today.hour < 19
                                              ? model.primaryColor
                                              : Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '${model.temperature ?? ""}°',
                                        style: TextStyle(
                                          fontSize: height / 12,
                                          color: model.today.hour > 6 &&
                                                  model.today.hour < 19
                                              ? model.primaryColor
                                              : Colors.white,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      // Container(
                                      //   height: height / 13,
                                      //   child:
                                      // ),
                                    ],
                                  ),
                                ),

                                ///City
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    0.0,
                                    height / 2.6,
                                    0.0,
                                    0.0,
                                  ),
                                  child: Text(
                                    '${model.cityName ?? ""}',
                                    style: TextStyle(
                                      fontSize: height / 23,
                                      color: model.primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),

                                ///Date
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    0.0,
                                    0.0,
                                    0.0,
                                    height / 15,
                                  ),
                                  child: Text(
                                    "${model.getDay(model.today.weekday)} | ${model.getMonth(model.today.month)} ${model.today.day}",
                                    style: TextStyle(
                                      fontSize: height / 45,
                                      color: model.primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),

                                ///Humidity and Temperature
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ///Humidity
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Humidity',
                                          style: TextStyle(
                                            fontSize: height / 45,
                                            color: model.primaryColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),

                                        Text(
                                          '${model.humidity ?? ""} %',
                                          style: TextStyle(
                                            fontSize: height / 24,
                                            color: model.primaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        // Container(
                                        //   height: height / 13,
                                        //   child:
                                        // ),
                                      ],
                                    ),

                                    SizedBox(
                                      width: width / 6,
                                    ),

                                    ///Temperature
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Temperature',
                                          style: TextStyle(
                                            fontSize: height / 45,
                                            color: model.primaryColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          '${model.temperature ?? ""}°',
                                          style: TextStyle(
                                            fontSize: height / 24,
                                            color: model.primaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        // Container(
                                        //   height: height / 13,
                                        //   child:
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  height: height / 40,
                                ),

                                ///PM values
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ///PM 1.0
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'PM 1.0',
                                          style: TextStyle(
                                            fontSize: height / 45,
                                            color: model.primaryColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        model.pm1 != null
                                            ? Text(
                                                '${model.pm1}',
                                                style: TextStyle(
                                                  fontSize: height / 30,
                                                  color: model.primaryColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            : FadingText(
                                                "..",
                                                style: TextStyle(
                                                  fontSize: height / 30,
                                                  color: model.primaryColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                        // Container(
                                        //   height: height / 13,
                                        //   child:
                                        // ),
                                      ],
                                    ),

                                    SizedBox(
                                      width: width / 12,
                                    ),

                                    ///PM 2.5
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'PM 2.5',
                                          style: TextStyle(
                                            fontSize: height / 45,
                                            color: model.primaryColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        model.pm2 != null
                                            ? Text(
                                                '${model.pm2}',
                                                style: TextStyle(
                                                  fontSize: height / 30,
                                                  color: model.primaryColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            : FadingText(
                                                "..",
                                                style: TextStyle(
                                                  fontSize: height / 30,
                                                  color: model.primaryColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                        // Container(
                                        //   height: height / 13,
                                        //   child:
                                        // ),
                                      ],
                                    ),

                                    SizedBox(
                                      width: width / 12,
                                    ),

                                    ///PM 10
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'PM 10',
                                          style: TextStyle(
                                            fontSize: height / 45,
                                            color: model.primaryColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        model.pm10 != null
                                            ? Text(
                                                '${model.pm10}',
                                                style: TextStyle(
                                                  fontSize: height / 30,
                                                  color: model.primaryColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            : FadingText(
                                                "..",
                                                style: TextStyle(
                                                  fontSize: height / 30,
                                                  color: model.primaryColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                        // Container(
                                        //   height: height / 13,
                                        //   child:
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),

                                // ///Re-Configure Button
                                // Container(
                                //   height: 50.0,
                                //   width: width / 2.5,
                                //   decoration: BoxDecoration(
                                //     color: Colors.white,
                                //     borderRadius:
                                //         BorderRadius.all(Radius.circular(10.0)),
                                //   ),
                                //   child: MaterialButton(
                                //     splashColor: model.color[600],
                                //     onPressed: () {
                                //       model.goToBluetoothScreen();
                                //     },
                                //     child: Text(
                                //       "Reconfigure",
                                //       style: TextStyle(
                                //         fontSize: 21,
                                //         color: Colors.black,
                                //         fontWeight: FontWeight.w300,
                                //       ),
                                //     ),
                                //   ),
                                //   // child: BusyButton(
                                //   //   title: "Reconfigure",
                                //
                                //   //   onPressed: () {},
                                //   // ),
                                // ),
                                //
                                // ///Got to Remote Button
                                // Container(
                                //   height: 50.0,
                                //   width: width / 2.5,
                                //   decoration: BoxDecoration(
                                //     borderRadius:
                                //         BorderRadius.all(Radius.circular(10.0)),
                                //     color: Colors.white,
                                //   ),
                                //   child: MaterialButton(
                                //     splashColor: model.color[600],
                                //     onPressed: () {
                                //       model.gotoRemoteScreen();
                                //     },
                                //     child: Text(
                                //       "Goto Remote",
                                //       style: TextStyle(
                                //         fontSize: 21,
                                //         color: Colors.black,
                                //         fontWeight: FontWeight.w300,
                                //       ),
                                //     ),
                                //   ),
                                //   // child: BusyButton(
                                //   //   title: "Reconfigure",
                                //
                                //   //   onPressed: () {},
                                //   // ),
                                // ),
                              ],
                            ),
                          )
                        : Center(
                            child: FadingText(
                              "....",
                              style: TextStyle(
                                fontSize: height / 20,
                                color: model.primaryColor,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),

                    ///Menu
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        model.today.hour > 6 && model.today.hour < 19
                            ? 10.0
                            : width / 1.1,
                        10.0,
                        model.today.hour > 6 && model.today.hour < 19
                            ? width / 1.1
                            : 10,
                        0.0,
                      ),
                      child: InkWell(
                        onTap: () {
                          model.menuToggle();
                        },
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          child: Icon(
                            Icons.menu,
                            color: model.today.hour > 6 && model.today.hour < 19
                                ? model.primaryColor
                                : Colors.white,
                            size: height / 27,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
