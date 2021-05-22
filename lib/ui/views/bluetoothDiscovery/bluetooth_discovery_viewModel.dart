import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/app/router.gr.dart';
import 'package:air_purifier/services/authentication_service.dart';
import 'package:air_purifier/services/bluetooth_service.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:stacked/stacked.dart';
import 'dart:async';

import 'package:stacked_services/stacked_services.dart';

class BluetoothDiscoveryViewModel extends BaseViewModel {
  List<BluetoothDevice> bluetoothList = [];
  List<BluetoothDiscoveryResult> allDevices = [];
  bool searchOngoing = true;
  FlutterBluetoothSerial flutterBluetoothSerial =
      FlutterBluetoothSerial.instance;
  StreamSubscription _streamSubscription;
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final BluetoothService bluetoothService = locator<BluetoothService>();
  void onModelReady() {
    flutterBluetoothSerial.requestEnable().then((value) {
      if (value) {
        _streamSubscription =
            flutterBluetoothSerial.startDiscovery().listen((event) {
          allDevices.add(event);
        }, onError: (error) {
          searchOngoing = false;
          notifyListeners();
        });
        _streamSubscription.onDone(() {
          searchOngoing = false;
          bluetoothList = [];

          for (int i = 0; i < allDevices.length; i++) {
            if (!bluetoothList.contains(allDevices[i].device) &&
                allDevices[i].device != null &&
                allDevices[i].device.name != null &&
                allDevices[i].device.name != "")
              bluetoothList.add(allDevices[i].device);
          }
          notifyListeners();
        });
      } else {
        onModelReady();
      }
    });
  }

  void goToBluetoothPage(BluetoothDevice device) {
    _streamSubscription.cancel();
    _navigationService.navigateTo(Routes.bluetoothView, arguments: device);
  }

  ///goto login screen
  void goToLoginScreen() {
    _authenticationService.signOut();
    _navigationService.clearStackAndShow(Routes.loginView);
  }

  void refresh() {
    _streamSubscription.cancel();
    bluetoothList = [];
    allDevices = [];
    searchOngoing = true;
    notifyListeners();
    onModelReady();
  }
}
