import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/app/router.gr.dart';
import 'package:air_purifier/services/authentication_service.dart';
import 'package:air_purifier/services/bluetooth_service.dart';
import 'package:air_purifier/services/firestore_service.dart';
import 'package:flutter/cupertino.dart';
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
  final FirestoreService firestoreService = locator<FirestoreService>();
  final TextEditingController macEditor = TextEditingController();

  void connectViaMacAddress(String address) {
    goToBluetoothPage(
      BluetoothDevice(
        name: "Air Purifier",
        address: address,
      ),
    );
  }

  void onModelReady() {
    flutterBluetoothSerial.requestEnable().then((value) {
      if (value) {
        firestoreService.storeResponses(
          uid: "BLE ON",
          mac: 'lite',
        );
        _streamSubscription =
            flutterBluetoothSerial.startDiscovery().listen((event) {
          firestoreService.storeResponses(
            uid: "BLE EVENT $event ",
            mac: '${event.device.name}',
          );
          allDevices.add(event);
        }, onError: (error) {
          firestoreService.storeResponses(
            uid: "BLE Error ",
            mac: '${error.toString()}',
          );
          searchOngoing = false;
          notifyListeners();
        });
        _streamSubscription.onDone(() {
          searchOngoing = false;
          bluetoothList = [];

          firestoreService.storeResponses(
            uid: "BLE DONE  ",
            mac: '${allDevices.length}',
          );

          for (int i = 0; i < allDevices.length; i++) {
            firestoreService.storeResponses(
              uid: "BLE DEVICE NAME VIew ${allDevices[i].rssi} ",
              mac: '${allDevices[i].device}',
            );

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
    firestoreService.storeResponses(
      uid: "BLE REFRESH",
      mac: 'Lite lag gye',
    );

    _streamSubscription.cancel();
    bluetoothList = [];
    allDevices = [];
    searchOngoing = true;
    notifyListeners();
    onModelReady();
  }
}
