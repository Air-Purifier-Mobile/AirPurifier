import 'package:air_purifier/app/locator.dart';
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
  String displayText = "Please switch On the Bluetooth";
  bool goingForWifi = false;

  void onModelReady() {
    bluetoothService.enableBluetooth().then((isEnabled) {
      if (isEnabled) {
        displayText = "Getting Devices";
        notifyListeners();
        bluetoothService.startScanningDevices((String event, bool change) {
          displayText = event;
          notifyListeners();

          if (change) {
            goingForWifi = true;
            onWifiModelReady();
            notifyListeners();
          }
        });
      }
    });
  }

  String displayWifiText = "Fetching available wifi devices..";
  List ssids = [];
  bool gotList = false;
  WifiService _wifiService = locator<WifiService>();

  void onWifiModelReady() {
    setBusy(true);
    Future.delayed(Duration(seconds: 3), () {
      _wifiService.getListOfWifi((String text) {
        displayText = text;
        notifyListeners();
      }).then((value) {
        ssids = value;
        gotList = true;
        setBusy(false);
        notifyListeners();
      });
    });
  }

  void wifiRefresh() {
    setBusy(true);
    displayText = "Fetching available wifi devices..";
    ssids = [];
    gotList = false;
    notifyListeners();
    bluetoothService.enableBluetooth().then((isEnabled) {
      if (isEnabled) {
        displayText = "Getting Devices";
        notifyListeners();
        bluetoothService.startScanningDevices((String event, bool change) {
          displayText = event;
          notifyListeners();

          if (change) {
            goingForWifi = true;
            onWifiModelReady();
            notifyListeners();
          }
        });
      }
    });
  }

  void onPressed(String ssid, BuildContext context) async {
    goingForWifi = false;
    displayText = "Sending SSID : $ssid to device";
    notifyListeners();
    bluetoothService.sendCommand("+SSID,$ssid\r\n");
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
                              Fluttertoast.showToast(
                                  msg: "Password is :" +
                                      passController.text.trim());
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
