import 'package:air_purifier/app/constants.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'bluetooth_discovery_viewModel.dart';

class BluetoothDiscoveryView extends StatelessWidget {
  const BluetoothDiscoveryView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<BluetoothDiscoveryViewModel>.reactive(
      viewModelBuilder: () => BluetoothDiscoveryViewModel(),
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: primaryColor,
          appBar: AppBar(
            backgroundColor: primaryColor,
            elevation: 0.0,
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
                  model.refresh();
                },
              ),
            ],
          ),
          body: Container(
            height: height,
            width: width,
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: height / 50,
                ),
                Container(
                  height: height / 5,
                  width: width / 3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/bluetooth.png",
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height / 15,
                ),
                Container(
                  width: width / 1.2,
                  height: height / 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Choose your device",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: height / 30,
                          fontFamily: 'Noah',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: height / 300,
                      ),
                      Text(
                        "Select Bluetooth",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: height / 45,
                          fontFamily: 'Noah',
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height / 80,
                ),
                Container(
                  color: Colors.white70,
                  height: 1,
                  width: width / 1.2,
                ),
                SizedBox(
                  height: height / 80,
                ),
                model.bluetoothList.length != 0
                    ? Container(
                        width: width / 1.2,
                        height: height / 2.5,
                        child: ListView.builder(
                          itemCount: model.bluetoothList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: width / 20,
                                vertical: height / 100,
                              ),
                              child: InkWell(
                                onTap: () {
                                  /// Pass the bluetooth ssid to next page and connect to it
                                  print(model.bluetoothList[index].address);
                                  model.goToBluetoothPage(
                                      model.bluetoothList[index]);
                                },
                                child: Container(
                                  width: width / 1.2,
                                  height: height / 13,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.bluetooth,
                                        color: Colors.white70,
                                        size: height / 30,
                                      ),
                                      SizedBox(
                                        width: width / 20,
                                      ),
                                      Text(
                                        model.bluetoothList[index].name.trim(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: height / 37,
                                          fontFamily: 'Noah',
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(vertical: height / 7),
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              model.searchOngoing
                                  ? CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    )
                                  : Container(),
                              model.searchOngoing
                                  ? SizedBox(
                                      height: height / 20,
                                    )
                                  : Container(),
                              Text(
                                model.searchOngoing
                                    ? "Searching for available devices"
                                    : "Please Refresh",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: height / 35,
                                  fontFamily: 'Noah',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                SizedBox(
                  height: height / 80,
                ),
                Container(
                  color: Colors.white70,
                  height: 1,
                  width: width / 1.2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
