import 'package:air_purifier/ui/shared/ui_helpers.dart';
import 'package:air_purifier/ui/views/chameleon_container/chameleon_container_view.dart';
import 'package:air_purifier/ui/views/knobs/knobs_view.dart';
import 'package:air_purifier/ui/views/remote%20control/remote_control_viewModel.dart';
import 'package:air_purifier/ui/widgets/busy_button.dart';
import 'package:air_purifier/ui/widgets/circular_slider.dart';
import 'package:air_purifier/ui/widgets/inputCounter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animations/loading_animations.dart';
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
                        children: [
                          SizedBox(
                            height: height / 20,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
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
                                  activeBgColors: [Colors.white, Colors.white],
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
                            ],
                          ),
                          SizedBox(
                            height: height / 20,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: height / 20,
                                width: width / 3,
                                decoration: BoxDecoration(
                                  color: model.primaryColor,
                                  borderRadius: BorderRadius.circular(10),
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
                              Container(
                                height: height / 20,
                                width: width / 2,
                                child: InputCounter(
                                  width: width / 3.5,
                                  value: double.parse(
                                      model.initialIndexForFanSpeed.toString()),
                                  setValue: model.setQuantity,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height / 30,
                          ),
                          Container(
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
                                    publishColorCallBack: model.publishMessage,
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
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
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
                              SizedBox(
                                height: height / 85,
                              ),
                              Container(
                                height: height / 25,
                                width: width / 3,
                                decoration: BoxDecoration(
                                  color: model.primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "LED Mode",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: height / 50,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height / 30,
                          ),
                          Container(
                            width: width / 1.5,
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: height / 18,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
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
                                  initialLabelIndex: model.initialIndexForPMode,
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
                              SizedBox(
                                height: height / 85,
                              ),
                              Container(
                                height: height / 25,
                                width: width / 3,
                                decoration: BoxDecoration(
                                  color: model.primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "Purifier Mode",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: height / 50,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
