import 'package:air_purifier/ui/shared/ui_helpers.dart';
import 'package:air_purifier/ui/views/chameleon_container/chameleon_container_view.dart';
import 'package:air_purifier/ui/views/knobs/knobs_view.dart';
import 'package:air_purifier/ui/views/remote%20control/remote_control_viewModel.dart';
import 'package:air_purifier/ui/widgets/busy_button.dart';
import 'package:air_purifier/ui/widgets/circular_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:stacked/stacked.dart';
import 'package:toggle_switch/toggle_switch.dart';

class RemoteControlView extends StatefulWidget {
  const RemoteControlView({Key key}) : super(key: key);

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
            Navigator.of(context).pop();
            return true;
          });
        }

        return WillPopScope(
          onWillPop: () {
            return _onBackPressed();
          },
          child: Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: model.isBusy
                    ? Container(
                        height: height,
                        width: width,
                        color: Color.fromRGBO(36, 37, 41, 1),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Container(
                        height: height,
                        width: width,
                        color: Color.fromRGBO(36, 37, 41, 1),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                10,
                                15,
                                10,
                                0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(42, 46, 51, 1),
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
                                        Colors.red,
                                        Colors.green[800]
                                      ],
                                      initialLabelIndex:
                                          model.initialIndexForSwitch,
                                      onToggle: (index) {
                                        model.publishMessage(
                                          index == 0 ? "APOFF" : "APON",
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            verticalSpaceLarge,
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                10,
                                15,
                                10,
                                0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: height / 20,
                                    width: width / 3,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(42, 46, 51, 1),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          offset: Offset(0.0, 5.0),
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Purifier Mode",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(42, 46, 51, 1),
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
                                        Color.fromRGBO(239, 173, 75, 1),
                                        Color.fromRGBO(239, 173, 75, 1),
                                        Color.fromRGBO(239, 173, 75, 1),
                                      ],
                                      initialLabelIndex:
                                          model.initialIndexForPMode,
                                      onToggle: (index) {
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
                                                msg:
                                                    "What was the input? $index",
                                              );
                                            }
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            verticalSpaceMedium,
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                10,
                                15,
                                10,
                                0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: height / 20,
                                    width: width / 3,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(42, 46, 51, 1),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          offset: Offset(0.0, 5.0),
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        "LED Mode",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(42, 46, 51, 1),
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
                                        Color.fromRGBO(239, 173, 75, 1),
                                        Color.fromRGBO(239, 173, 75, 1),
                                        Color.fromRGBO(239, 173, 75, 1),
                                      ],
                                      labels: [
                                        "Auto",
                                        "Manual",
                                      ],
                                      onToggle: (index) {
                                        model.publishMessage(
                                            index == 0 ? "APLA" : "APLM");
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            verticalSpaceMedium,
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                10,
                                15,
                                10,
                                0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: height / 20,
                                    width: width / 3,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(42, 46, 51, 1),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          offset: Offset(0.0, 5.0),
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Fan Speed",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),

                                  /// Add Fan Icon
                                ],
                              ),
                            ),
                            verticalSpaceMedium,
                            Container(
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(42, 46, 51, 1),
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
                                inactiveFgColor: Colors.white,
                                activeBgColors: [
                                  Color.fromRGBO(239, 173, 75, 1),
                                  Color.fromRGBO(239, 173, 75, 1),
                                  Color.fromRGBO(239, 173, 75, 1),
                                  Color.fromRGBO(239, 173, 75, 1),
                                ],
                                minWidth: width / 3,
                                onToggle: (index) {
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
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                ChameleonContainerView(),
                                KnobsView(
                                  initialBlue: model.blue,
                                  initialGreen: model.green,
                                  initialRed: model.red,
                                  publishColorCallBack: model.publishMessage,
                                ),
                              ],
                            ),
                          ],
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
