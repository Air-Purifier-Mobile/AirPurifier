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
                Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0, 1.0],
                      colors: [
                        model.color[800],
                        model.color[400],
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

                      verticalSpaceMassive,

                      Container(
                        height: 50.0,
                        width: width / 2.5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: BusyButton(
                            title: "Goto Remote",
                            textStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                            ),
                            onPressed: () {
                              ///Remote
                              model.gotoRemoteScreen();
                            }),
                      ),
                      verticalSpaceLarge,
                      Container(
                        height: 50.0,
                        width: width / 2.5,
                        decoration: BoxDecoration(
                          color: Colors.red[300],
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: BusyButton(
                            title: "Logout",
                            textStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                            ),
                            onPressed: () {
                              ///Remote
                              model.logout();
                            }),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    0.0,
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
              ],
            ),
          ),
        );
      },
    );
  }
}
