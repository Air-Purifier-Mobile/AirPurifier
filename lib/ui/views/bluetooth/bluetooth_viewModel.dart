import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/app/router.gr.dart';
import 'package:air_purifier/services/bluetooth_service.dart';
import 'package:air_purifier/services/wifi_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BluetoothViewModel extends BaseViewModel {
  final BluetoothService bluetoothService = locator<BluetoothService>();
  final DialogService _dialogService = locator<DialogService>();
  final TextEditingController passController = TextEditingController();
  final NavigationService _navigationService = locator<NavigationService>();
  String displayText = "Please switch On the Bluetooth";
  bool goingForWifi = false;
  List ssids = [];
  bool gotList = false;

  //Callback for changing display text
  void changeDisplayTextCallBack(String event) {
    displayText = event;
    notifyListeners();
  }

  ///goto login screen
  void goToLoginScreen() {
    _navigationService.clearStackAndShow(Routes.loginView);
  }

  //Callback for changing to wifi
  void goToWifiScreen() {
    try {
      goingForWifi = true;
      notifyListeners();
    } catch (error) {
      Fluttertoast.showToast(msg: "Error in goToWifiScreen" + error.toString());
    }
  }

  void goToBluetoothScreen() {
    try {
      goingForWifi = false;
      notifyListeners();
    } catch (error) {
      Fluttertoast.showToast(msg: "Error in goToWifiScreen" + error.toString());
    }
  }

  void onModelReady() {
    bluetoothService
        .enableBluetooth(changeDisplayTextCallBack, goToWifiScreen,
            updateSSIDList, goToBluetoothScreen)
        .then((isEnabled) {
      if (isEnabled) {
        displayText = "Getting Devices";
        bluetoothService.startScanningDevices();
        notifyListeners();
      }
    });
    // Future.delayed(Duration(seconds: 3),
    //     (){
    //       goToWifiScreen();
    //     });
  }

  void updateSSIDList(List list) {
    ssids = list;
    notifyListeners();
  }

  void wifiRefresh() {
    gotList = false;
    displayText = "Sending command to fetch SSIDs";
    bluetoothService.sendCommand("+SCAN?\r\n");
    notifyListeners();
  }

  void onPressed(String ssid, BuildContext context) async {
    //Fluttertoast.showToast(msg: ssid);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Center(
          child: Container(
            height: MediaQuery.of(context).size.height / 7,
            width: MediaQuery.of(context).size.width * 3 / 4,
            child: Material(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        20.0,
                        20.0,
                        0.0,
                        0.0,
                      ),
                      child: Text(
                        "Enter Password",
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              20.0,
                              20.0,
                              20.0,
                              10.0,
                            ),
                            child: TextField(
                              controller: passController,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: Icon(
                              Icons.check_circle,
                              size: 30.0,
                            ),
                            onPressed: () {
                              ///Send Password to Device
                              bluetoothService.password = passController.text;
                              goingForWifi = false;
                              displayText = "Sending SSID : $ssid to device";
                              bluetoothService.selectedSSID = ssid;
                              bluetoothService.sendCommand("+SSID,$ssid\r\n");
                              bluetoothService.sendCommand(
                                "+PSS,${passController.text}\r\n",
                              );
                              notifyListeners();
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
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
