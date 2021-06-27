import 'package:air_purifier/app/constants.dart';
import 'package:air_purifier/app/locator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

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
        void _modalBottomSheetMenu() {
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
                      color: Color(0xFF05051C),
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
                            "Enter MAC ID mentioned on your Aeolus device's package box:",
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: height / 45,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Noah",
                            ),
                          ),
                          Text(
                            "(Important: Please make sure your Aeolus device is discoverable in your phone's bluetooth settings)",
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: height / 45,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Noah",
                            ),
                          ),
                          TextFormField(
                            controller: model.macEditor,
                            cursorColor: Colors.white70,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: height / 40,
                            ),
                            decoration: InputDecoration(
                              hintText: "XX:XX:XX:XX:XX:XX",
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
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: Color(0xFF05051C),
                                        fontSize: height / 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (model.macEditor.text.contains(":") &&
                                      model.macEditor.text.trim().length ==
                                          17) {
                                    print("Mac Address");
                                    Navigator.of(context).pop();
                                    model.connectViaMacAddress(
                                      model.macEditor.text.trim(),
                                    );
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "Please Enter valid MAC ID",
                                    );
                                  }
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
                                      "Save",
                                      style: TextStyle(
                                        color: Color(0xFF05051C),
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

        return Scaffold(
          resizeToAvoidBottomInset: false,
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
          body: SingleChildScrollView(
            child: Container(
              width: width,
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                          height: height / 3.2,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                          model.bluetoothList[index].name
                                              .trim(),
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
                          padding: EdgeInsets.symmetric(
                            vertical:
                                model.searchOngoing ? height / 10 : height / 8,
                          ),
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                model.searchOngoing
                                    ? CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
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
                    height: model.searchOngoing ? height / 80 : 0.0,
                  ),
                  Container(
                    color: Colors.white70,
                    height: 1,
                    width: width / 1.2,
                  ),
                  Text(
                    "\n\nor\n",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      fontFamily: 'Noah',
                      color: Colors.white,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      print("Hello");
                      _modalBottomSheetMenu();
                    },
                    child: Text(
                      "Enter MAC manually?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        fontFamily: 'Noah',
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
