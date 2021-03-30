import 'package:air_purifier/ui/shared/ui_helpers.dart';
import 'package:air_purifier/ui/views/chameleon_container/chameleon_container_view.dart';
import 'package:air_purifier/ui/views/knobs/knobs_view.dart';
import 'package:air_purifier/ui/views/remote%20control/remote_control_viewModel.dart';
import 'package:air_purifier/ui/widgets/busy_button.dart';
import 'package:air_purifier/ui/widgets/circular_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:stacked/stacked.dart';

class RemoteControlView extends StatelessWidget {
  const RemoteControlView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
              child: Container(
                height: height,
                width: width,
                color: Colors.purpleAccent,
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
                            height: height / 12,
                            width: width / 5,
                            color: Colors.amber,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: height / 15,
                            width: width / 3,
                            color: Colors.amber,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        10,
                        15,
                        10,
                        0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: height / 15,
                            width: width / 4,
                            color: Colors.amber,
                          ),
                          Container(
                            height: height / 15,
                            width: width / 4,
                            color: Colors.amber,
                          ),
                          Container(
                            height: height / 15,
                            width: width / 4,
                            color: Colors.amber,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        10,
                        15,
                        10,
                        0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: height / 15,
                            width: width / 3.5,
                            color: Colors.amber,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: height / 15,
                                width: width / 4,
                                color: Colors.amber,
                              ),
                              Container(
                                height: height / 15,
                                width: width / 4,
                                color: Colors.amber,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(
                    //     width / 50,
                    //     15,
                    //     width / 50,
                    //     0,
                    //   ),
                    //   child: Container(
                    //     height: height / 2.1,
                    //     width: width / 1.05,
                    //     padding: EdgeInsets.all(width / 50),
                    //     color: Color.fromRGBO(
                    //       model.red,
                    //       model.green,
                    //       model.blue,
                    //       1,
                    //     ),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Container(
                    //           decoration: BoxDecoration(
                    //             color: Colors.black,
                    //             borderRadius:
                    //                 BorderRadius.circular(height / 12),
                    //           ),
                    //           height: width / 3.4,
                    //           width: width / 3.4,
                    //           child: CircularSlider(
                    //             changeColor: model.changeColor,
                    //             color: Color.fromARGB(255, 255, 0, 0),
                    //             colorCode: 'r',
                    //           ),
                    //           // child: SleekCircularSlider(
                    //           //   min: 0,
                    //           //   max: 255,
                    //           //   initialValue: 128,
                    //           //   appearance: CircularSliderAppearance(
                    //           //     size: height / 16,
                    //           //     angleRange: 270,
                    //           //     animationEnabled: true,
                    //           //     infoProperties: InfoProperties(
                    //           //       modifier: (value) {
                    //           //         return value.floor().toString();
                    //           //       },
                    //           //       mainLabelStyle: TextStyle(
                    //           //         fontSize: 20,
                    //           //         color: Colors.white,
                    //           //       ),
                    //           //     ),
                    //           //     customWidths: CustomSliderWidths(
                    //           //       trackWidth: 20,
                    //           //       progressBarWidth: 20,
                    //           //     ),
                    //           //   ),
                    //           // ),
                    //         ),
                    //         Container(
                    //           decoration: BoxDecoration(
                    //             color: Colors.white,
                    //             borderRadius:
                    //                 BorderRadius.circular(height / 12),
                    //           ),
                    //           height: width / 3.4,
                    //           width: width / 3.4,
                    //           child: CircularSlider(
                    //             changeColor: model.changeColor,
                    //             color: Color.fromARGB(255, 0, 255, 0),
                    //             colorCode: 'g',
                    //           ),
                    //         ),
                    //         Container(
                    //           decoration: BoxDecoration(
                    //             color: Colors.cyanAccent,
                    //             borderRadius:
                    //                 BorderRadius.circular(height / 12),
                    //           ),
                    //           height: width / 3.4,
                    //           width: width / 3.4,
                    //           child: CircularSlider(
                    //             changeColor: model.changeColor,
                    //             color: Color.fromARGB(255, 0, 0, 255),
                    //             colorCode: 'b',
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ChameleonContainerView(),
                        KnobsView(),
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
