import 'package:air_purifier/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:stacked/stacked.dart';

import 'bluetooth_viewModel.dart';

class BluetoothView extends StatelessWidget {
  const BluetoothView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<BluetoothViewModel>.reactive(
      viewModelBuilder: () => BluetoothViewModel(),
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        return KeyboardDismisser(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(42, 46, 51, 1),
              title: Text(model.goingForWifi
                  ? "Configure Wifi"
                  : "Configure Bluetooth"),
              leading: IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  model.goToLoginScreen();
                },
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                  ),
                  onPressed: () {
                    if (model.goingForWifi)
                      model.wifiRefresh();
                    else
                      model.onModelReady();
                  },
                ),
              ],
            ),
            body: !model.goingForWifi
                ? SingleChildScrollView(
                    child: Container(
                      height: height,
                      width: width,
                      color: Color.fromRGBO(36, 37, 41, 1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: width / 12,
                            width: width / 12,
                            child: CircularProgressIndicator(),
                          ),
                          verticalSpaceLarge,
                          Text(
                            model.displayText,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : model.ssids.length != 0
                    ? Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: model.ssids.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(3, 5, 3, 5),
                                child: ListTile(
                                  title: Text(
                                    model.ssids[index],
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      model.onPressed(
                                          model.ssids[index], context);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    : Container(
                        color: Color.fromRGBO(36, 37, 41, 1),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                model.displayText,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              FadingText(
                                "....",
                                style: TextStyle(
                                  color: Colors.white,
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
