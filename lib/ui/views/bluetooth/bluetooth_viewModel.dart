import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/app/router.gr.dart';
import 'package:air_purifier/services/authentication_service.dart';
import 'package:air_purifier/services/bluetooth_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BluetoothViewModel extends BaseViewModel {
  final BluetoothService bluetoothService = locator<BluetoothService>();
  final TextEditingController passController = TextEditingController();
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  String displayText = "Please switch On the Bluetooth";
  bool goingForWifi = false;
  List<String> ssids = [];
  bool gotList = false;
  String finalSSID = '';
  String finalPass = '';

  //Callback for changing display text
  void changeDisplayTextCallBack(String event) {
    displayText = event;
    notifyListeners();
  }

  ///goto login screen
  void goToLoginScreen() {
    _authenticationService.signOut();
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

  void sendPasswordToDevice(String ssid, String pass) {
    goingForWifi = false;
    finalSSID = ssid;
    finalPass = pass;
    displayText = "Sending SSID : $finalSSID to device";
    bluetoothService.selectedSSID = ssid;
    bluetoothService.password = pass;
    Future.delayed(Duration(milliseconds: 500), () {
      bluetoothService.sendCommand("+SSID,$ssid\r\n");
    });
    Future.delayed(Duration(milliseconds: 500), () {
      bluetoothService.sendCommand(
        "+PSS," + finalPass.trim() + "\r\n",
      );
    });
    finalSSID = '';
    finalPass = '';
    notifyListeners();
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
        displayText = "Initialising bluetooth connectivity";
        bluetoothService.startScanningDevices();
        notifyListeners();
      } else {
        Fluttertoast.showToast(msg: 'Please turn on bluetooth to proceed.');
        onModelReady();
      }
    });
  }

  void updateSSIDList(List<String> list) {
    ssids = list;
    notifyListeners();
  }

  void wifiRefresh() {
    gotList = false;
    displayText = "Sending command to fetch SSIDs";
    bluetoothService.allWifiDevices = [];
    Future.delayed(Duration(milliseconds: 500), () {
      bluetoothService.sendCommand("+SCAN?\r\n");
    });
    notifyListeners();
  }
}
