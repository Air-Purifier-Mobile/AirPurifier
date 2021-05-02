import 'package:air_purifier/app/constants.dart';
import 'package:air_purifier/ui/views/chameleon_container/chameleon_container_view.dart';
import 'package:air_purifier/ui/views/remote%20control/remote_control_viewModel.dart';
import 'package:air_purifier/ui/widgets/speedController.dart';
import 'package:air_purifier/ui/widgets/toggleLedMode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:stacked/stacked.dart';

class RemoteControlView extends StatefulWidget {
  final Function refreshCallBack;
  RemoteControlView({this.refreshCallBack, Key key}) : super(key: key);

  @override
  _RemoteControlViewState createState() => _RemoteControlViewState();
}

class _RemoteControlViewState extends State<RemoteControlView> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    print("Rebuilding");
    return ViewModelBuilder<RemoteControlViewModel>.reactive(
      viewModelBuilder: () => RemoteControlViewModel(),
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        Future<bool> _onBackPressed() {
          return Future.delayed(Duration(seconds: 0), () {
            model.unsubscribeToTopic();
            widget.refreshCallBack();
            return true;
          });
        }

        return WillPopScope(
          onWillPop: () {
            return _onBackPressed();
          },
          child: Scaffold(
            backgroundColor: primaryColor,
            body: SafeArea(
              child: model.isBusy
                  ? Container(
                      height: height,
                      width: width,
                      color: primaryColor,
                      child: Center(
                        child: LoadingBouncingGrid.circle(
                          backgroundColor: Colors.white70,
                        ),
                      ),
                    )
                  : Container(
                      height: height,
                      width: width,
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height * 0.06,
                          ),
                          Container(
                            height: height / 6.5,
                            width: width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/fan.png"),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          // Row(
                          //   mainAxisSize: MainAxisSize.max,
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Container(
                          //       height: height / 20,
                          //       width: width / 3,
                          //       alignment: Alignment.centerLeft,
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(10),
                          //       ),
                          //       child: Text(
                          //         "\t\t\t\t\t\tFan",
                          //         style: TextStyle(
                          //           color: Colors.white,
                          //           fontSize: 18,
                          //           fontWeight: FontWeight.w500,
                          //         ),
                          //       ),
                          //     ),
                          //     Padding(
                          //       padding: EdgeInsets.fromLTRB(
                          //         0.0,
                          //         0.0,
                          //         width / 20,
                          //         0.0,
                          //       ),
                          //       child: Container(
                          //         decoration: BoxDecoration(
                          //           color: primaryColor,
                          //           borderRadius: BorderRadius.circular(10),
                          //           boxShadow: [
                          //             BoxShadow(
                          //               color: Colors.black,
                          //               offset: Offset(0.0, 5.0),
                          //               blurRadius: 5.0,
                          //             ),
                          //           ],
                          //         ),
                          //         child: ToggleSwitch(
                          //           inactiveFgColor: Colors.white,
                          //           labels: [
                          //             "OFF",
                          //             "ON",
                          //           ],
                          //           activeBgColors: [
                          //             Colors.white,
                          //             Colors.white
                          //           ],
                          //           activeFgColor: primaryColor,
                          //           inactiveBgColor: primaryColor,
                          //           initialLabelIndex:
                          //               model.initialIndexForSwitch,
                          //           onToggle: (index) {
                          //             model.initialIndexForSwitch = index;
                          //             model.toggleLedMode();
                          //             // model.publishMessage(
                          //             //   index == 0 ? "APOFF" : "APON",
                          //             // );
                          //           },
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: height / 40,
                          // ),
                          // Row(
                          //   mainAxisSize: MainAxisSize.max,
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Container(
                          //       height: height / 20,
                          //       width: width / 3,
                          //       alignment: Alignment.centerLeft,
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(10),
                          //       ),
                          //       child: Text(
                          //         "\t\t\t\t\t\tFan Speed",
                          //         style: TextStyle(
                          //           color: Colors.white,
                          //           fontSize: 18,
                          //           fontWeight: FontWeight.w500,
                          //         ),
                          //       ),
                          //     ),
                          //     Padding(
                          //       padding: EdgeInsets.fromLTRB(
                          //         0.0,
                          //         0.0,
                          //         width / 20,
                          //         0.0,
                          //       ),
                          //       child: Container(
                          //         decoration: BoxDecoration(
                          //           color: primaryColor,
                          //           borderRadius: BorderRadius.circular(10),
                          //           boxShadow: [
                          //             BoxShadow(
                          //               color: Colors.black,
                          //               offset: Offset(0.0, 5.0),
                          //               blurRadius: 5.0,
                          //             ),
                          //           ],
                          //         ),
                          //         child: ToggleSwitch(
                          //           initialLabelIndex:
                          //               model.initialIndexForFanSpeed,
                          //           labels: [
                          //             "1",
                          //             "2",
                          //             "3",
                          //             "4",
                          //           ],
                          //           activeFgColor: primaryColor,
                          //           inactiveBgColor: primaryColor,
                          //           inactiveFgColor: Colors.white,
                          //           activeBgColors: [
                          //             Colors.white,
                          //             Colors.white,
                          //             Colors.white,
                          //             Colors.white,
                          //           ],
                          //           minWidth: width / 7,
                          //           onToggle: (index) {
                          //             model.initialIndexForFanSpeed = index;
                          //             switch (index) {
                          //               case 0:
                          //                 {
                          //                   model.publishMessage("1");
                          //                 }
                          //                 break;
                          //               case 1:
                          //                 {
                          //                   model.publishMessage("2");
                          //                 }
                          //                 break;
                          //               case 2:
                          //                 {
                          //                   model.publishMessage("3");
                          //                 }
                          //                 break;
                          //               case 3:
                          //                 {
                          //                   model.publishMessage("4");
                          //                 }
                          //                 break;
                          //               default:
                          //                 {
                          //                   Fluttertoast.showToast(
                          //                     msg: "What was the input? $index",
                          //                   );
                          //                 }
                          //             }
                          //           },
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: height / 40,
                          // ),
                          // Row(
                          //   mainAxisSize: MainAxisSize.max,
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Container(
                          //       height: height / 20,
                          //       width: width / 3,
                          //       alignment: Alignment.centerLeft,
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(10),
                          //       ),
                          //       child: Text(
                          //         "\t\t\t\t\t\tAC Fan",
                          //         style: TextStyle(
                          //           color: Colors.white,
                          //           fontSize: 18,
                          //           fontWeight: FontWeight.w500,
                          //         ),
                          //       ),
                          //     ),
                          //     Padding(
                          //       padding: EdgeInsets.fromLTRB(
                          //         0.0,
                          //         0.0,
                          //         width / 20,
                          //         0.0,
                          //       ),
                          //       child: Container(
                          //         decoration: BoxDecoration(
                          //           color: primaryColor,
                          //           borderRadius: BorderRadius.circular(10),
                          //           boxShadow: [
                          //             BoxShadow(
                          //               color: Colors.black,
                          //               offset: Offset(0.0, 5.0),
                          //               blurRadius: 5.0,
                          //             ),
                          //           ],
                          //         ),
                          //         child: ToggleSwitch(
                          //           inactiveFgColor: Colors.white,
                          //           labels: [
                          //             "OFF",
                          //             "ON",
                          //           ],
                          //           activeBgColors: [
                          //             Colors.white,
                          //             Colors.white
                          //           ],
                          //           activeFgColor: primaryColor,
                          //           inactiveBgColor: primaryColor,
                          //           initialLabelIndex:
                          //               model.initialIndexForAcSwitch,
                          //           onToggle: (index) {
                          //             model.initialIndexForAcSwitch = index;
                          //             model.publishMessage(
                          //               index == 0 ? "ACOFF" : "ACON",
                          //             );
                          //           },
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: height / 40,
                          // ),
                          // Row(
                          //   mainAxisSize: MainAxisSize.max,
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Container(
                          //       height: height / 20,
                          //       width: width / 3,
                          //       alignment: Alignment.centerLeft,
                          //       decoration: BoxDecoration(
                          //         color: primaryColor,
                          //         borderRadius: BorderRadius.circular(10),
                          //       ),
                          //       child: Text(
                          //         "\t\t\t\t\t\tAC Fan Speed",
                          //         style: TextStyle(
                          //           color: Colors.white,
                          //           fontSize: 18,
                          //           fontWeight: FontWeight.w500,
                          //         ),
                          //       ),
                          //     ),
                          //     Padding(
                          //       padding: EdgeInsets.fromLTRB(
                          //         0.0,
                          //         0.0,
                          //         width / 20,
                          //         0.0,
                          //       ),
                          //       child: Container(
                          //         decoration: BoxDecoration(
                          //           color: primaryColor,
                          //           borderRadius: BorderRadius.circular(10),
                          //           boxShadow: [
                          //             BoxShadow(
                          //               color: Colors.black,
                          //               offset: Offset(0.0, 5.0),
                          //               blurRadius: 5.0,
                          //             ),
                          //           ],
                          //         ),
                          //         child: ToggleSwitch(
                          //           initialLabelIndex:
                          //               model.initialIndexForAcSpeed,
                          //           labels: [
                          //             "1",
                          //             "2",
                          //             "3",
                          //             "4",
                          //           ],
                          //           activeFgColor: primaryColor,
                          //           inactiveBgColor: primaryColor,
                          //           inactiveFgColor: Colors.white,
                          //           activeBgColors: [
                          //             Colors.white,
                          //             Colors.white,
                          //             Colors.white,
                          //             Colors.white,
                          //           ],
                          //           minWidth: width / 7,
                          //           onToggle: (index) {
                          //             model.initialIndexForAcSpeed = index;
                          //             switch (index) {
                          //               case 0:
                          //                 {
                          //                   model.publishMessage("AC1");
                          //                 }
                          //                 break;
                          //               case 1:
                          //                 {
                          //                   model.publishMessage("AC2");
                          //                 }
                          //                 break;
                          //               case 2:
                          //                 {
                          //                   model.publishMessage("AC3");
                          //                 }
                          //                 break;
                          //               case 3:
                          //                 {
                          //                   model.publishMessage("AC4");
                          //                 }
                          //                 break;
                          //               default:
                          //                 {
                          //                   Fluttertoast.showToast(
                          //                     msg: "What was the input? $index",
                          //                   );
                          //                 }
                          //             }
                          //           },
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: height / 40,
                          // ),
                          // Row(
                          //   mainAxisSize: MainAxisSize.max,
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Container(
                          //       height: height / 25,
                          //       width: width / 3,
                          //       alignment: Alignment.centerLeft,
                          //       decoration: BoxDecoration(
                          //         color: primaryColor,
                          //         borderRadius: BorderRadius.circular(10),
                          //       ),
                          //       child: Text(
                          //         "\t\t\t\t\t\tLED Mode",
                          //         style: TextStyle(
                          //           color: Colors.white,
                          //           fontSize: height / 50,
                          //           fontWeight: FontWeight.w500,
                          //         ),
                          //       ),
                          //     ),
                          //     SizedBox(
                          //       height: height / 85,
                          //     ),
                          //     Padding(
                          //       padding: EdgeInsets.fromLTRB(
                          //         0.0,
                          //         0.0,
                          //         width / 20,
                          //         0.0,
                          //       ),
                          //       child: Container(
                          //         decoration: BoxDecoration(
                          //           color: primaryColor,
                          //           borderRadius: BorderRadius.circular(10),
                          //           boxShadow: [
                          //             BoxShadow(
                          //               color: Colors.black,
                          //               offset: Offset(0.0, 5.0),
                          //               blurRadius: 5.0,
                          //             ),
                          //           ],
                          //         ),
                          //         child: ToggleSwitch(
                          //           initialLabelIndex:
                          //               model.initialIndexForLEDMode,
                          //           inactiveFgColor: Colors.white,
                          //           activeBgColors: [
                          //             Colors.white,
                          //             Colors.white,
                          //             Colors.white,
                          //           ],
                          //           activeFgColor: primaryColor,
                          //           inactiveBgColor: primaryColor,
                          //           labels: [
                          //             "Auto",
                          //             "Manual",
                          //           ],
                          //           onToggle: (index) {
                          //             model.initialIndexForLEDMode = index;
                          //             model.publishMessage(
                          //                 index == 0 ? "APLA" : "APLM");
                          //           },
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: height / 40,
                          // ),
                          // Row(
                          //   mainAxisSize: MainAxisSize.max,
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Container(
                          //       height: height / 25,
                          //       width: width / 3,
                          //       alignment: Alignment.centerLeft,
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(10),
                          //       ),
                          //       child: Text(
                          //         "\t\t\t\t\t\tPurifier Mode",
                          //         style: TextStyle(
                          //           color: Colors.white,
                          //           fontSize: height / 50,
                          //           fontWeight: FontWeight.w500,
                          //         ),
                          //       ),
                          //     ),
                          //     SizedBox(
                          //       height: height / 85,
                          //     ),
                          //     Padding(
                          //       padding: EdgeInsets.fromLTRB(
                          //         0.0,
                          //         0.0,
                          //         width / 20,
                          //         0.0,
                          //       ),
                          //       child: Container(
                          //         decoration: BoxDecoration(
                          //           color: primaryColor,
                          //           borderRadius: BorderRadius.circular(10),
                          //           boxShadow: [
                          //             BoxShadow(
                          //               color: Colors.black,
                          //               offset: Offset(0.0, 5.0),
                          //               blurRadius: 5.0,
                          //             ),
                          //           ],
                          //         ),
                          //         child: ToggleSwitch(
                          //           labels: [
                          //             "Auto",
                          //             "Manual",
                          //             "Sleep",
                          //           ],
                          //           inactiveFgColor: Colors.white,
                          //           activeBgColors: [
                          //             Colors.white,
                          //             Colors.white,
                          //             Colors.white,
                          //           ],
                          //           activeFgColor: primaryColor,
                          //           inactiveBgColor: primaryColor,
                          //           initialLabelIndex:
                          //               model.initialIndexForPMode,
                          //           onToggle: (index) {
                          //             model.initialIndexForPMode = index;
                          //             switch (index) {
                          //               case 0:
                          //                 {
                          //                   model.publishMessage("APMA");
                          //                 }
                          //                 break;
                          //               case 1:
                          //                 {
                          //                   model.publishMessage("APMM");
                          //                 }
                          //                 break;
                          //               case 2:
                          //                 {
                          //                   model.publishMessage("APMS");
                          //                 }
                          //                 break;
                          //               default:
                          //                 {
                          //                   Fluttertoast.showToast(
                          //                     msg: "What was the input? $index",
                          //                   );
                          //                 }
                          //             }
                          //           },
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: height / 20,
                          // ),
                          //
                          // // Padding(
                          // //   padding: EdgeInsets.fromLTRB(
                          // //     0.0,
                          // //     height / 20,
                          // //     0.0,
                          // //     0.0,
                          // //   ),
                          // //   child: Container(
                          // //     height: height / 2.6,
                          // //     width: width,
                          // //     child: Stack(
                          // //       alignment: Alignment.center,
                          // //       children: [
                          // //         Container(
                          // //           alignment: Alignment.center,
                          // //           child: KnobsView(
                          // //             initialBlue: model.blue,
                          // //             initialGreen: model.green,
                          // //             initialRed: model.red,
                          // //             publishColorCallBack:
                          // //                 model.publishMessage,
                          // //           ),
                          // //         ),
                          // //         Container(
                          // //           height: height / 6,
                          // //           width: height / 6,
                          // //           clipBehavior: Clip.hardEdge,
                          // //           decoration: BoxDecoration(
                          // //             shape: BoxShape.circle,
                          // //           ),
                          // //           child: ChameleonContainerView(),
                          // //         ),
                          // //       ],
                          // //     ),
                          // //   ),
                          // // ),
                          // Center(
                          //   child: model.ledModeManual
                          //       ? Container(
                          //           width: width * 0.8,
                          //           child: HuePicker(
                          //             trackHeight: 10.0,
                          //             thumbShape: RoundSliderThumbShape(
                          //               enabledThumbRadius:
                          //                   model.ledModeManual ? 10.0 : 0.0,
                          //             ),
                          //             initialColor: HSVColor.fromColor(
                          //               model.ledColor,
                          //             ),
                          //             onChangeEnd: (color) {
                          //               model.changeLedColor(color.toColor());
                          //               print("On Change End");
                          //               print(color.toColor().blue);
                          //               print(color.toColor().red);
                          //               print(color.toColor().green);
                          //             },
                          //           ),
                          //         )
                          //       : Container(
                          //           width: width * 0.8,
                          //           height: 7.5,
                          //           decoration: BoxDecoration(
                          //             color: Color.fromRGBO(
                          //               model.ledColor.red,
                          //               model.ledColor.green,
                          //               model.ledColor.blue,
                          //               1,
                          //             ),
                          //             borderRadius: BorderRadius.circular(10.0),
                          //           ),
                          //         ),
                          // ),
                          // Padding(
                          //   padding: EdgeInsets.fromLTRB(
                          //     width / 1.5,
                          //     height / 80 + (model.ledModeManual ? 0.0 : 2.50),
                          //     0.0,
                          //     0.0,
                          //   ),
                          //   child: LedToggle(
                          //     ledMode: model.ledModeManual,
                          //     backColor: primaryColor,
                          //     toggleLedMode: model.toggleLedMode,
                          //   ),
                          // ),
                          // StepperTouch(
                          //   direction: Axis.vertical,
                          //   initialValue: 2,
                          // ),
                          SizedBox(
                            height: height / 18,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  SpeedController(
                                    model.fanSpeed,
                                    height: height / 7,
                                    width: width / 7.5,
                                    maxValue: 4,
                                    minValue: 1,
                                    initialValue: model.fanSpeed,
                                    contentColor: primaryColor,
                                    arrowColor: primaryColor,
                                    backgroundColor: Colors.white,
                                    enabled: model.fanState,
                                    changeCallBack: model.changeFanSpeed,
                                  ),
                                  SizedBox(
                                    height: height / 60,
                                  ),
                                  GestureDetector(
                                    onTap: () => model.toggleFan(),
                                    child: Container(
                                      height: height / 18,
                                      width: height / 18,
                                      decoration: BoxDecoration(
                                        color: model.fanState
                                            ? Colors.white
                                            : HexColor("4a4a68"),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.power_settings_new_rounded,
                                        size: width / 12,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height / 60,
                                  ),
                                  Text(
                                    "Fan",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: height / 45,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  SpeedController(
                                    model.purifierSpeed,
                                    height: height / 7,
                                    width: width / 7.5,
                                    maxValue: 4,
                                    minValue: 1,
                                    initialValue: model.purifierSpeed,
                                    enabled: model.purifierState,
                                    contentColor: primaryColor,
                                    arrowColor: primaryColor,
                                    backgroundColor: Colors.white,
                                    changeCallBack: model.changePurifierSpeed,
                                  ),
                                  SizedBox(
                                    height: height / 60,
                                  ),
                                  GestureDetector(
                                    onTap: () => model.togglePurifier(),
                                    child: Container(
                                      height: height / 18,
                                      width: height / 18,
                                      decoration: BoxDecoration(
                                        color: model.purifierState
                                            ? Colors.white
                                            : HexColor("4a4a68"),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.power_settings_new_rounded,
                                        size: width / 12,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height / 60,
                                  ),
                                  Text(
                                    "Purifier",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: height / 45,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height / 30,
                          ),
                          Center(
                            child: Container(
                              width: width * 0.868,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white54,
                                ),
                                borderRadius: BorderRadius.circular(
                                  height / 34,
                                ),
                              ),
                              child: FlutterToggleTab(
                                // width in percent, to set full width just set to 100
                                width: width * 0.2,
                                borderRadius: 30,
                                height: height / 17,
                                initialIndex: model.purifierMode,
                                selectedIndex: model.purifierMode,
                                selectedBackgroundColors: [
                                  Colors.white,
                                ],
                                unSelectedBackgroundColors: [
                                  primaryColor,
                                ],
                                selectedTextStyle: TextStyle(
                                  color: primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                                unSelectedTextStyle: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                labels: ["Auto", "Manual", "Sleep"],
                                selectedLabelIndex: (index) {
                                  print("Selected Index $index");
                                  switch (index) {
                                    case 0:
                                      {
                                        model.publishMessage("APMA");
                                      }
                                      break;
                                    case 1:
                                      {
                                        model.publishMessage("APMM");
                                      }
                                      break;
                                    case 2:
                                      {
                                        model.publishMessage("APMS");
                                      }
                                      break;
                                    default:
                                      {
                                        Fluttertoast.showToast(
                                          msg: "What was the input? $index",
                                        );
                                      }
                                  }
                                  model.setPurifierMode(index);
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height / 40,
                          ),
                          Center(
                            child: Text(
                              "Purifier Mode",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: height / 45,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: height / 60,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  color: Colors.white,
                                  height: 1,
                                  width: width * 0.35,
                                ),
                                SizedBox(
                                  width: width * 0.01,
                                ),
                                Container(
                                  height: height / 25,
                                  width: height / 25,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: ChameleonContainerView(),
                                ),
                                SizedBox(
                                  width: width * 0.01,
                                ),
                                Container(
                                  color: Colors.white,
                                  height: 1,
                                  width: width * 0.35,
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Container(
                              height: height / 25,
                              width: width * 0.7,
                              child: SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: 1.0,
                                  thumbColor: HexColor("dd453a"),
                                  disabledThumbColor: HexColor("dd453a"),
                                  activeTrackColor: Colors.white,
                                  inactiveTrackColor: Colors.white,
                                  disabledActiveTrackColor: Colors.white70,
                                  disabledInactiveTrackColor: Colors.white70,
                                ),
                                child: Slider(
                                  value: model.red.toDouble(),
                                  min: 0.0,
                                  max: 255.0,
                                  onChangeEnd: (val) {
                                    print(val.toString());
                                    model.changeRed(val, true);
                                  },
                                  onChanged: model.ledState
                                      ? (val) {
                                          model.changeRed(val, false);
                                        }
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: width * 0.7,
                              height: height / 25,
                              child: SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: 1.0,
                                  thumbColor: HexColor("32db44"),
                                  disabledThumbColor: HexColor("32db44"),
                                  activeTrackColor: Colors.white,
                                  inactiveTrackColor: Colors.white,
                                  disabledActiveTrackColor: Colors.white70,
                                  disabledInactiveTrackColor: Colors.white70,
                                ),
                                child: Slider(
                                  value: model.green.toDouble(),
                                  min: 0.0,
                                  max: 255.0,
                                  onChangeEnd: (val) {
                                    print(val.toString());
                                    model.changeGreen(val, true);
                                  },
                                  onChanged: model.ledState
                                      ? (val) {
                                          model.changeGreen(val, false);
                                        }
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: width * 0.7,
                              height: height / 25,
                              child: SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: 1.0,
                                  thumbColor: HexColor("3b7ddb"),
                                  disabledThumbColor: HexColor("3b7ddb"),
                                  activeTrackColor: Colors.white,
                                  inactiveTrackColor: Colors.white,
                                  disabledActiveTrackColor: Colors.white70,
                                  disabledInactiveTrackColor: Colors.white70,
                                ),
                                child: Slider(
                                  value: model.blue.toDouble(),
                                  min: 0.0,
                                  max: 255.0,
                                  onChangeEnd: (val) {
                                    print(val.toString());
                                    model.changeBlue(val, true);
                                  },
                                  onChanged: model.ledState
                                      ? (val) {
                                          model.changeBlue(val, false);
                                        }
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height / 40,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              width / 1.5,
                              height / 80 + (model.ledState ? 0.0 : 2.50),
                              0.0,
                              0.0,
                            ),
                            child: LedToggle(
                              ledMode: model.ledState,
                              backColor: primaryColor,
                              toggleLedMode: model.toggleLedMode,
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
