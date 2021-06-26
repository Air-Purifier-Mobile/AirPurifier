import 'package:air_purifier/app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:stacked/stacked.dart';

import 'bluetooth_viewModel.dart';

class BluetoothView extends StatelessWidget {
  final BluetoothDevice device;
  BluetoothView({Key key, this.device}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BluetoothViewModel>.reactive(
      viewModelBuilder: () => BluetoothViewModel(),
      onModelReady: (model) => model.onModelReady(device),
      builder: (context, model, child) {
        return KeyboardDismisser(
          child: Scaffold(
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
                    if (model.goingForWifi)
                      model.wifiRefresh();
                    else
                      model.onModelReady(device);
                  },
                ),
              ],
            ),
            body: !model.goingForWifi
                ? BlueTooth(
                    text: model.displayText,
                  )
                : Wifi(
                    wifiList: model.ssids,
                    connect: model.sendPasswordToDevice,
                    connectSSID: model.sendSSIDToDevice,
                  ),
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class BlueTooth extends StatelessWidget {
  String text;
  BlueTooth({
    this.text,
  });
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: height / 15,
          ),
          Text(
            "Bluetooth Configuration",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: height / 36,
              fontFamily: 'Noah',
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: height / 40,
          ),
          Container(
            width: width / 1.5,
            alignment: Alignment.center,
            child: Text(
              "Please wait while we establish your bluetooth connection. This process may take up to 3-4 minutes.",
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: height / 45,
                fontFamily: 'Noah',
                color: Colors.white70,
              ),
            ),
          ),
          SizedBox(
            height: height / 15,
          ),
          Container(
            height: height / 2.5,
            width: width / 1.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/bluetooth.png",
                ),
              ),
            ),
          ),
          SizedBox(
            height: height / 20,
          ),
          Container(
            width: width / 1.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Status: ",
                  style: TextStyle(
                    fontSize: height / 45,
                    color: Colors.white,
                  ),
                ),
                Flexible(
                  child: Text(
                    text,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: height / 45,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class Wifi extends StatelessWidget {
  List<String> wifiList;
  Function connect;
  Function connectSSID;
  Wifi({
    this.wifiList,
    this.connect,
    this.connectSSID,
  });
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    void _modalBottomSheetMenu() {
      TextEditingController password = TextEditingController();
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          context: context,
          builder: (builder) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                height: height / 3,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(width / 10),
                    topRight: Radius.circular(width / 10),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enter Password : ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: height / 30,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Noah",
                        ),
                      ),
                      TextFormField(
                        controller: password,
                        cursorColor: Colors.white70,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: height / 40,
                        ),
                        decoration: InputDecoration(
                          hintText: "Password",
                          labelStyle: TextStyle(
                            color: Colors.white70,
                            fontSize: height / 40,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white70,
                            fontSize: height / 40,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: width / 3,
                              height: height / 15,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(height / 30),
                                color: Colors.black,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: height / 40,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              connect(password.text.trim());
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: width / 3,
                              height: height / 15,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(height / 30),
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Connect",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: height / 40,
                                  ),
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
            );
          });
    }

    // List<String> list = [
    //   "Ez God",
    //   "TD",
    //   "Nachos",
    //   "Zelzar ",
    //   "DDD",
    //   "Blazkowicz",
    //   "Popoye",
    // ];
    return Container(
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
                  "assets/wifi.png",
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
                  "Connect your device",
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
                  "Select wifi",
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
          wifiList.length != 0
              ? Container(
                  width: width / 1.2,
                  height: height / 2.5,
                  child: ListView.builder(
                    itemCount: wifiList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width / 20,
                          vertical: height / 100,
                        ),
                        child: InkWell(
                          onTap: () {
                            connectSSID(wifiList[index].trim());
                            _modalBottomSheetMenu();
                          },
                          child: Container(
                            width: width / 1.2,
                            height: height / 13,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.wifi,
                                  color: Colors.white70,
                                  size: height / 30,
                                ),
                                SizedBox(
                                  width: width / 20,
                                ),
                                Text(
                                  wifiList[index].trim(),
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
                  padding: EdgeInsets.symmetric(vertical: height / 6),
                  child: Container(
                    child: Text(
                      "Searching for Wifi networks available ",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: height / 35,
                        fontFamily: 'Noah',
                        color: Colors.white,
                      ),
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
    );
  }
}
