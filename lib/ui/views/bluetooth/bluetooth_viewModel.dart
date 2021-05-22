import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/app/router.gr.dart';
import 'package:air_purifier/services/authentication_service.dart';
import 'package:air_purifier/services/bluetooth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BluetoothViewModel extends BaseViewModel {
  BluetoothDevice selectedDevice;
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

  ///Callback for changing display text
  void changeDisplayTextCallBack(String event) {
    displayText = event;
    notifyListeners();
  }

  /// Refresh Connection

  ///goto login screen
  void goToLoginScreen() {
    _authenticationService.signOut();
    _navigationService.clearStackAndShow(Routes.loginView);
  }

  ///Callback for changing to wifi
  void goToWifiScreen(var refresh) {
    try {
      goingForWifi = true;
      notifyListeners();
      if (refresh is bool && refresh) {
        wifiRefresh();
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Error in goToWifiScreen" + error.toString());
    }
  }

  void sendPasswordToDevice(String pass) {
    if (!bluetoothService.checkConnectionToBluetooth()) {
      goingForWifi = false;
      finalPass = pass;
      displayText = "Sending password to device";
      bluetoothService.password = pass;
      Future.delayed(Duration(milliseconds: 500), () {
        bluetoothService.sendCommand(
          "+PSS," + finalPass.trim() + "\r\n",
        );
        bluetoothService.firestoreService.storeResponses(
          uid: "Responses",
          mac: 'PASS fired',
        );
      });
      notifyListeners();
    }
  }

  void sendSSIDToDevice(String ssid) {
    if (!bluetoothService.checkConnectionToBluetooth()) {
      finalSSID = ssid;
      bluetoothService.selectedSSID = ssid;
      displayText = "Sending SSID : $finalSSID to device";
      Future.delayed(Duration(milliseconds: 500), () {
        bluetoothService.sendCommand("+SSID,$finalSSID\r\n");
        bluetoothService.firestoreService.storeResponses(
          uid: "Responses",
          mac: 'SSID fired',
        );
      });
      notifyListeners();
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

  void onModelReady(BluetoothDevice device) {
    selectedDevice = device;
    bluetoothService
        .enableBluetooth(changeDisplayTextCallBack, goToWifiScreen,
            updateSSIDList, goToBluetoothScreen)
        .then((isEnabled) {
      if (isEnabled) {
        displayText = "Initialising bluetooth connectivity";
        bluetoothService.connectDevice(selectedDevice);
        notifyListeners();
      } else {
        Fluttertoast.showToast(msg: 'Please turn on bluetooth to proceed.');
      }
    });
  }

  void updateSSIDList(List<String> list) {
    ssids = [];
    ssids = list.toSet().toList();
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
