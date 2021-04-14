import 'package:air_purifier/ui/views/chameleon_container/chameleon_container_view.dart';
import 'package:air_purifier/ui/views/knobs/knobs_view.dart';
import 'package:air_purifier/ui/views/remote%20control/remote_control_viewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:stacked/stacked.dart';
import 'package:toggle_switch/toggle_switch.dart';

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
            backgroundColor: model.primaryColor,
            body: SafeArea(
              child: model.isBusy
                  ? Container(
                      height: height,
                      width: width,
                      color: model.primaryColor,
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
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: height / 20,
                                width: width / 3,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "\t\t\t\t\t\tFan",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  0.0,
                                  0.0,
                                  width / 20,
                                  0.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: model.primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(0.0, 5.0),
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                  ),
                                  child: ToggleSwitch(
                                    inactiveFgColor: Colors.white,
                                    labels: [
                                      "OFF",
                                      "ON",
                                    ],
                                    activeBgColors: [
                                      Colors.white,
                                      Colors.white
                                    ],
                                    activeFgColor: model.primaryColor,
                                    inactiveBgColor: model.primaryColor,
                                    initialLabelIndex:
                                        model.initialIndexForSwitch,
                                    onToggle: (index) {
                                      model.initialIndexForSwitch = index;
                                      model.publishMessage(
                                        index == 0 ? "APOFF" : "APON",
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height / 40,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: height / 20,
                                width: width / 3,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "\t\t\t\t\t\tFan Speed",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  0.0,
                                  0.0,
                                  width / 20,
                                  0.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: model.primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(0.0, 5.0),
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                  ),
                                  child: ToggleSwitch(
                                    initialLabelIndex:
                                        model.initialIndexForFanSpeed,
                                    labels: [
                                      "1",
                                      "2",
                                      "3",
                                      "4",
                                    ],
                                    activeFgColor: model.primaryColor,
                                    inactiveBgColor: model.primaryColor,
                                    inactiveFgColor: Colors.white,
                                    activeBgColors: [
                                      Colors.white,
                                      Colors.white,
                                      Colors.white,
                                      Colors.white,
                                    ],
                                    minWidth: width / 7,
                                    onToggle: (index) {
                                      model.initialIndexForFanSpeed = index;
                                      switch (index) {
                                        case 0:
                                          {
                                            model.publishMessage("1");
                                          }
                                          break;
                                        case 1:
                                          {
                                            model.publishMessage("2");
                                          }
                                          break;
                                        case 2:
                                          {
                                            model.publishMessage("3");
                                          }
                                          break;
                                        case 3:
                                          {
                                            model.publishMessage("4");
                                          }
                                          break;
                                        default:
                                          {
                                            Fluttertoast.showToast(
                                              msg: "What was the input? $index",
                                            );
                                          }
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height / 40,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: height / 20,
                                width: width / 3,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "\t\t\t\t\t\tAC Fan",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  0.0,
                                  0.0,
                                  width / 20,
                                  0.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: model.primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(0.0, 5.0),
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                  ),
                                  child: ToggleSwitch(
                                    inactiveFgColor: Colors.white,
                                    labels: [
                                      "OFF",
                                      "ON",
                                    ],
                                    activeBgColors: [
                                      Colors.white,
                                      Colors.white
                                    ],
                                    activeFgColor: model.primaryColor,
                                    inactiveBgColor: model.primaryColor,
                                    initialLabelIndex:
                                        model.initialIndexForAcSwitch,
                                    onToggle: (index) {
                                      model.initialIndexForAcSwitch = index;
                                      model.publishMessage(
                                        index == 0 ? "ACOFF" : "ACON",
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height / 40,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: height / 20,
                                width: width / 3,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: model.primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "\t\t\t\t\t\tAC Fan Speed",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  0.0,
                                  0.0,
                                  width / 20,
                                  0.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: model.primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(0.0, 5.0),
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                  ),
                                  child: ToggleSwitch(
                                    initialLabelIndex:
                                        model.initialIndexForAcSpeed,
                                    labels: [
                                      "1",
                                      "2",
                                      "3",
                                      "4",
                                    ],
                                    activeFgColor: model.primaryColor,
                                    inactiveBgColor: model.primaryColor,
                                    inactiveFgColor: Colors.white,
                                    activeBgColors: [
                                      Colors.white,
                                      Colors.white,
                                      Colors.white,
                                      Colors.white,
                                    ],
                                    minWidth: width / 7,
                                    onToggle: (index) {
                                      model.initialIndexForAcSpeed = index;
                                      switch (index) {
                                        case 0:
                                          {
                                            model.publishMessage("AC1");
                                          }
                                          break;
                                        case 1:
                                          {
                                            model.publishMessage("AC2");
                                          }
                                          break;
                                        case 2:
                                          {
                                            model.publishMessage("AC3");
                                          }
                                          break;
                                        case 3:
                                          {
                                            model.publishMessage("AC4");
                                          }
                                          break;
                                        default:
                                          {
                                            Fluttertoast.showToast(
                                              msg: "What was the input? $index",
                                            );
                                          }
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height / 40,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: height / 25,
                                width: width / 3,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: model.primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "\t\t\t\t\t\tLED Mode",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: height / 50,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height / 85,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  0.0,
                                  0.0,
                                  width / 20,
                                  0.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: model.primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(0.0, 5.0),
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                  ),
                                  child: ToggleSwitch(
                                    initialLabelIndex:
                                        model.initialIndexForLEDMode,
                                    inactiveFgColor: Colors.white,
                                    activeBgColors: [
                                      Colors.white,
                                      Colors.white,
                                      Colors.white,
                                    ],
                                    activeFgColor: model.primaryColor,
                                    inactiveBgColor: model.primaryColor,
                                    labels: [
                                      "Auto",
                                      "Manual",
                                    ],
                                    onToggle: (index) {
                                      model.initialIndexForLEDMode = index;
                                      model.publishMessage(
                                          index == 0 ? "APLA" : "APLM");
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height / 40,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: height / 25,
                                width: width / 3,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "\t\t\t\t\t\tPurifier Mode",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: height / 50,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height / 85,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  0.0,
                                  0.0,
                                  width / 20,
                                  0.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: model.primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(0.0, 5.0),
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                  ),
                                  child: ToggleSwitch(
                                    labels: [
                                      "Auto",
                                      "Manual",
                                      "Sleep",
                                    ],
                                    inactiveFgColor: Colors.white,
                                    activeBgColors: [
                                      Colors.white,
                                      Colors.white,
                                      Colors.white,
                                    ],
                                    activeFgColor: model.primaryColor,
                                    inactiveBgColor: model.primaryColor,
                                    initialLabelIndex:
                                        model.initialIndexForPMode,
                                    onToggle: (index) {
                                      model.initialIndexForPMode = index;
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
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height / 20,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              0.0,
                              height / 20,
                              0.0,
                              0.0,
                            ),
                            child: Container(
                              height: height / 2.6,
                              width: width,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: KnobsView(
                                      initialBlue: model.blue,
                                      initialGreen: model.green,
                                      initialRed: model.red,
                                      publishColorCallBack:
                                          model.publishMessage,
                                    ),
                                  ),
                                  Container(
                                    height: height / 6,
                                    width: height / 6,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ChameleonContainerView(),
                                  ),
                                ],
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
