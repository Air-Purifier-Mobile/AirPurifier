import 'package:air_purifier/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        return Scaffold(
          appBar: AppBar(
            title: Text(
                model.goingForWifi ? "Configure Wifi" : "Configure Bluetooth"),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: width / 12,
                          width: width / 12,
                          child: CircularProgressIndicator(),
                        ),
                        verticalSpaceMedium,
                        Text(
                          model.displayText,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                )
              : model.ssids.length != 0
                  ? ListView.builder(
                      itemCount: model.ssids.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          key: Key(model.ssids[index]),
                          title: Text(
                            model.ssids[index],
                            style: TextStyle(fontSize: 20.0),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              model.onPressed(model.ssids[index], context);
                            },
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(model.displayText),
                          FadingText("...."),
                        ],
                      ),
                    ),
        );
      },
    );
  }
}
