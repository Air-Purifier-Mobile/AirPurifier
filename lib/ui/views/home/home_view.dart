import 'package:air_purifier/ui/shared/ui_helpers.dart';
import 'package:air_purifier/ui/widgets/busy_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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
          // appBar: AppBar(
          //   actions: [
          //     IconButton(
          //       icon: Icon(
          //         Icons.logout,
          //       ),
          //       onPressed: () {
          //         model.logout();
          //       },
          //     )
          //   ],
          // ),
          body: SafeArea(
            child: Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                SingleChildScrollView(
                  child: Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0, 0.5, 1.0],
                        colors: [
                          model.color[800],
                          model.color[600],
                          model.color[200],
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        verticalSpaceLarge,

                        ///City
                        Container(
                          height: height / 18,
                          child: model.temperature == null
                              ? FadingText(
                                  "....",
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                )
                              : Text(
                                  '${model.cityName}',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                        ),

                        ///Temp
                        Container(
                          height: height / 18,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Temperature ',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              model.temperature == null
                                  ? FadingText(
                                      "....",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    )
                                  : Text(
                                      '- ${model.temperature}°C',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                            ],
                          ),
                        ),

                        ///Feel
                        Container(
                          height: height / 18,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Feels Like ',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              model.temperature == null
                                  ? FadingText(
                                      "....",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    )
                                  : Text(
                                      '- ${model.feelsLike}°C',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                            ],
                          ),
                        ),

                        ///Description
                        Container(
                          height: height / 18,
                          child: model.temperature == null
                              ? FadingText(
                                  "....",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                )
                              : Text(
                                  '${model.description}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                        ),

                        ///Humidity
                        Container(
                          height: height / 18,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Humidity ',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              model.temperature == null
                                  ? FadingText(
                                      "....",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    )
                                  : Text(
                                      '- ${model.humidity}%',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                            ],
                          ),
                        ),

                        ///PM 1.0
                        Container(
                          height: height / 18,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'PM 1.0 : ',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              model.pm1 == null
                                  ? FadingText(
                                      "....",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    )
                                  : Text(
                                      '${model.pm1}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                            ],
                          ),
                        ),

                        ///PM 2.5
                        Container(
                          height: height / 18,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'PM 2.5 : ',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              model.pm2 == null
                                  ? FadingText(
                                      "....",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    )
                                  : Text(
                                      '${model.pm2}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                            ],
                          ),
                        ),

                        ///PM 10
                        Container(
                          height: height / 18,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'PM 10 : ',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              model.pm10 == null
                                  ? FadingText(
                                      "....",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    )
                                  : Text(
                                      '${model.pm10}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                            ],
                          ),
                        ),

                        verticalSpaceLarge,

                        ///Re-Configure Button
                        Container(
                          height: 50.0,
                          width: width / 2.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: MaterialButton(
                            splashColor: model.color[600],
                            onPressed: () {
                              model.goToBluetoothScreen();
                            },
                            child: Text(
                              "Reconfigure",
                              style: TextStyle(
                                fontSize: 21,
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          // child: BusyButton(
                          //   title: "Reconfigure",

                          //   onPressed: () {},
                          // ),
                        ),

                        verticalSpaceLarge,

                        ///Got to Remote Button
                        Container(
                          height: 50.0,
                          width: width / 2.5,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            color: Colors.white,
                          ),
                          child: MaterialButton(
                            splashColor: model.color[600],
                            onPressed: () {
                              model.gotoRemoteScreen();
                            },
                            child: Text(
                              "Goto Remote",
                              style: TextStyle(
                                fontSize: 21,
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          // child: BusyButton(
                          //   title: "Reconfigure",

                          //   onPressed: () {},
                          // ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    width / 1.1,
                    10.0,
                    10.0,
                    0.0,
                  ),
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        model.refresh();
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    10.0,
                    10.0,
                    width / 1.1,
                    0.0,
                  ),
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        model.logout();
                      },
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
