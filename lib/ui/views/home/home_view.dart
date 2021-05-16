import 'package:air_purifier/app/constants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
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
      onModelReady: (model) => model.getLocation(),
      builder: (context, model, child) {
        void _modalBottomSheetMenu() {
          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              context: context,
              builder: (builder) {
                return Container(
                  height: height / 3,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(width / 10),
                      topRight: Radius.circular(width / 10),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width / 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Enter Device Name : ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: height / 30,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Noah",
                          ),
                        ),
                        TextFormField(
                          controller: model.nameEditor,
                          cursorColor: Colors.white70,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: height / 40,
                          ),
                          decoration: InputDecoration(
                            hintText: model.currentName[model.lastDevice],
                            labelStyle: TextStyle(
                              color: Colors.white70,
                              fontSize: height / 40,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.white70,
                              fontSize: height / 40,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height / 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                model.nameEditor.text =
                                    model.currentName[model.lastDevice];
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: width / 3,
                                height: height / 15,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(height / 30),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: height / 40,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                model.updateName(
                                    model.nameEditor.value.text.trim());
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: width / 3,
                                height: height / 15,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(height / 30),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: height / 40,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        }
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            elevation: 0,
            leading: InkWell(
              onTap: () {
                model.scaffoldKey.currentState.openDrawer();
                model.notifyListeners();
              },
              child: Container(
                width: 50.0,
                height: 50.0,
                child: Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: height / 27,
                ),
              ),
            ),
          ),
          backgroundColor: primaryColor,
          key: model.scaffoldKey,
          drawer: Drawer(
            elevation: 0.0,
            child: LayoutBuilder(
              builder: (context, constraint) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraint.maxHeight,
                      maxWidth: width * 0.65,
                    ),
                    child: IntrinsicHeight(
                      child: Container(
                        color: primaryColor,
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
                            Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children:
                                model.currentName.map<Widget>((name) {
                                  return ListTile(
                                    key: Key(name),
                                    onTap: () {
                                      /// Select Device
                                      model.changeDevice(name);
                                      Navigator.of(context).pop();
                                    },
                                    horizontalTitleGap: 0.0,
                                    leading: Icon(
                                      Icons.device_hub,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      name,
                                      style: TextStyle(
                                        fontSize: height / 45,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                // Go to Bluetooth
                                model.goToBluetoothScreen();
                              },
                              horizontalTitleGap: 0.0,
                              leading: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              title: Text(
                                "Add Device",
                                style: TextStyle(
                                  fontSize: height / 45,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
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
                                // Go to Bluetooth
                                model.removeDevice();
                              },
                              horizontalTitleGap: 0.0,
                              leading: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              title: Text(
                                "Remove Current Device",
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
                    ),
                  ),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              ///uncomment in prod
              if ((model.pm1 == null || model.pm1 != "") &&
                  (model.pm2 == null || model.pm2 != "") &&
                  (model.pm10 == null || model.pm10 != "")) {
                Fluttertoast.showToast(
                  msg: "Please turn on power supply to device",
                );
              } else
                model.gotoRemoteScreen();
            },
            child: Container(
              height: width / 12,
              width: width / 12,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                     "assets/remote_day.png",
                  ),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          resizeToAvoidBottomInset: false,
          body: GestureDetector(
            onTap: () {
              FirebaseAnalytics().logEvent(
                name: "Touched_home_Screen",
                parameters: {"Key1": "Value 1"},
              );
            },
            onVerticalDragEnd: (e) {
              if (e.primaryVelocity > 0) {
                model.refresh();
              }
            },
            onHorizontalDragEnd: (e) {
              if (e.primaryVelocity > 0) {
                model.scaffoldKey.currentState.openDrawer();
                model.notifyListeners();
              } else {
                model.scaffoldKey.currentState.isEndDrawerOpen?
                Navigator.of(context).pop():null;
                model.notifyListeners();
              }
            },
            child: KeyboardDismisser(
              child: model.temperature != null
                  ? Container(
                height: height,
                width: width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    ///City
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        0.0,
                        height * 0.1,
                        0.0,
                        height*0.02,
                      ),
                      child: Text(
                        '${model.cityName ?? ""}',
                        style: TextStyle(
                          fontSize: height / 35,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),

                    ///Humidity and Temperature
                    Container(
                      height: height * 0.08333,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        children: [
                          ///Temperature
                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: height/35,
                                width: width*0.08,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/temperature.png'
                                      ),
                                    )
                                ),
                              ),
                              Text(
                                '${model.temperature ?? ""}°',
                                style: TextStyle(
                                  fontSize: height / 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              // Container(
                              //   height: height / 13,
                              //   child:
                              // ),
                            ],
                          ),
                          SizedBox(
                            width: width / 10,
                          ),
                          ///Humidity
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [

                              Container(
                                height: height/35,
                                width: width*0.08,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/humidity.png'
                                      ),
                                    )
                                ),
                              ),

                              Text(
                                '${model.humidity ?? ""} %',
                                style: TextStyle(
                                  fontSize: height / 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
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
                    ),

                    ///Fan Image and Slider
                    Container(
                      color: Colors.red,
                      height: height/2.5,
                      width: width*0.9,
                    ),

                    SizedBox(
                      height: height/20,
                    ),
                    Icon(
                      Icons.wifi_outlined,
                      color: Colors.white70,
                      size: height/25,
                    ),

                    ///Device Name
                    InkWell(
                      onTap: () {
                        print("hello mujhe dabaya gaya hai");
                        _modalBottomSheetMenu();
                      },
                      child: Container(
                        width: width * 0.8,
                        alignment: Alignment.center,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              0.0,
                              height * 0.02,
                              0.0,
                              0.0,
                            ),
                            child: Text(
                              "${model.currentName[model.lastDevice] ?? ""}",
                              style: TextStyle(
                                fontSize: height / 45,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          // child: !model.editingStatus
                          //     ? Text(
                          //         "${model.currentName[model.lastDevice] ?? ""}",
                          //         style: TextStyle(
                          //           fontSize: height / 45,
                          //           color: model.primaryColor,
                          //           fontWeight: FontWeight.w500,
                          //         ),
                          //       )
                          //     : Padding(
                          //         padding: EdgeInsets.fromLTRB(
                          //           0.0,
                          //           0.0,
                          //           0.0,
                          //           height * 0.0333,
                          //         ),
                          //         child: Container(
                          //           height: height / 20,
                          //           width: width * 0.5,
                          //           child: TextFormField(
                          //             showCursor: true,
                          //             autofocus: true,
                          //             decoration:
                          //                 InputDecoration(
                          //               enabledBorder:
                          //                   UnderlineInputBorder(
                          //                 borderSide:
                          //                     BorderSide(
                          //                   color: primaryColor,
                          //                 ),
                          //               ),
                          //               focusedBorder:
                          //                   UnderlineInputBorder(
                          //                 borderSide:
                          //                     BorderSide(
                          //                   color: primaryColor,
                          //                 ),
                          //               ),
                          //               border:
                          //                   UnderlineInputBorder(
                          //                 borderSide:
                          //                     BorderSide(
                          //                   color: primaryColor,
                          //                 ),
                          //               ),
                          //             ),
                          //             cursorColor: primaryColor,
                          //             controller:
                          //                 model.nameEditor,
                          //             textAlign:
                          //                 TextAlign.center,
                          //             onFieldSubmitted: (text) {
                          //               model.editingStatus =
                          //                   false;
                          //               model.updateName(text);
                          //             },
                          //             onEditingComplete: () {
                          //               print("Complelte");
                          //             },
                          //           ),
                          //         ),
                          //       ),
                        ),
                      ),
                    ),

                    /// Divider
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        0.0,
                        height * 0.01,
                        0.0,
                        height * 0.0333,
                      ),
                      child: Container(
                        width: width / 5,
                        child: Divider(
                          thickness: 1,
                          color: Colors.white,
                        ),
                      ),
                    ),



                    ///PM values
                    Container(
                      height: height * 0.0833,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        children: [
                          ///PM 1.0
                          // Column(
                          //   mainAxisSize: MainAxisSize.min,
                          //   children: [
                          //     Text(
                          //       'PM 1.0',
                          //       style: TextStyle(
                          //         fontSize: height / 45,
                          //         color: Colors.white,
                          //         fontWeight: FontWeight.w400,
                          //       ),
                          //     ),
                          //     model.pm1 != null
                          //         ? Text(
                          //       '${model.pm1}',
                          //       style: TextStyle(
                          //         fontSize: height / 30,
                          //         color: Colors.white,
                          //         fontWeight:
                          //         FontWeight.w500,
                          //       ),
                          //     )
                          //         : FadingText(
                          //       "..",
                          //       style: TextStyle(
                          //         fontSize: height / 30,
                          //         color: Colors.white,
                          //         fontWeight:
                          //         FontWeight.w500,
                          //       ),
                          //     ),
                          //     // Container(
                          //     //   height: height / 13,
                          //     //   child:
                          //     // ),
                          //   ],
                          // ),

                          // SizedBox(
                          //   width: width / 12,
                          // ),

                          ///PM 2.5
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'PM 2.5',
                                style: TextStyle(
                                  fontSize: height / 45,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              model.pm2 != null
                                  ? Text(
                                '${model.pm2}',
                                style: TextStyle(
                                  fontSize: height / 30,
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight.w500,
                                ),
                              )
                                  : FadingText(
                                "..",
                                style: TextStyle(
                                  fontSize: height / 30,
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight.w500,
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
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              model.pm10 != null
                                  ? Text(
                                '${model.pm10}',
                                style: TextStyle(
                                  fontSize: height / 30,
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight.w500,
                                ),
                              )
                                  : FadingText(
                                "..",
                                style: TextStyle(
                                  fontSize: height / 30,
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight.w500,
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
                    ),
                  ],
                ),
              )
                  : Container(
                height: height,
                width: width,
                child: Center(
                  child: FadingText(
                    "....",
                    style: TextStyle(
                      fontSize: height / 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
