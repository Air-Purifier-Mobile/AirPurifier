import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/app/router.gr.dart';
import 'package:air_purifier/services/authentication_service.dart';
import 'package:air_purifier/services/bluetooth_service.dart';
import 'package:air_purifier/services/firestore_service.dart';
import 'package:flutter_blue/flutter_blue.dart' as fb;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:stacked/stacked.dart';
import 'dart:async';

import 'package:stacked_services/stacked_services.dart';

class BluetoothDiscoveryViewModel extends BaseViewModel {
  List<BluetoothDevice> bluetoothList = [];
  List<fb.ScanResult> allDevices = [];
  bool searchOngoing = true;
  FlutterBluetoothSerial flutterBluetoothSerial =
      FlutterBluetoothSerial.instance;
  StreamSubscription _streamSubscription;
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final BluetoothService bluetoothService = locator<BluetoothService>();
  final FirestoreService firestoreService = locator<FirestoreService>();
  fb.FlutterBlue flutterBlue = fb.FlutterBlue.instance;

  void onModelReady() {
    flutterBluetoothSerial.requestEnable().then((value) {
      if (value) {
        // Start scanning
        flutterBlue.startScan(
            scanMode: fb.ScanMode.balanced, timeout: Duration(seconds: 4));
        print("Searching ble\n\n");
        firestoreService.storeResponses(
          uid: "BLE ON",
          mac: 'Scanning Start',
        );
        _streamSubscription = flutterBlue.scanResults.listen((event) {
          // firestoreService.storeResponses(
          //   uid: "BLE EVENT $event ",
          //   mac: '${event.device.name}',
          // );
          //
          print("Event : some shit happened\n\n");
          allDevices = event;
          allDevices.forEach((element) {
            print("Hello there was an event right?");
            print(element.device.name);
          });
          print("Done : some shit happened\n\n");
          searchOngoing = false;
          bluetoothList = [];
          firestoreService.storeResponses(
            uid: "BLE DONE  ",
            mac: '${allDevices.length}',
          );
          for (int i = 0; i < allDevices.length; i++) {
            firestoreService.storeResponses(
              uid: "BLE DEVICE NAME VIew $i",
              mac:
                  'Name: ${allDevices[i].device.name} ID: ${allDevices[i].device.id.id}',
            );
            if (!bluetoothList.contains(allDevices[i].device) &&
                allDevices[i].device != null &&
                allDevices[i].device.name != null &&
                allDevices[i].device.name != "")
              bluetoothList.add(BluetoothDevice(
                name: allDevices[i].device.name,
                address: allDevices[i].device.id.id,
              ));
          }
          Future.delayed(Duration(seconds: 1), () {
            notifyListeners();
          });
        }, onError: (error) {
          print("Error : some shit happened\n\n");
          firestoreService.storeResponses(
            uid: "BLE Error ",
            mac: '${error.toString()}',
          );
          searchOngoing = false;
          notifyListeners();
        });
        _streamSubscription.onDone(() {
          print("Done wtf???");
        });
      } else {
        onModelReady();
      }
    });
  }

  void goToBluetoothPage(BluetoothDevice device) {
    flutterBlue.stopScan();
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
    flutterBlue.stopScan();
    _streamSubscription.cancel();
    bluetoothList = [];
    allDevices = [];
    searchOngoing = true;
    notifyListeners();
    onModelReady();
  }
}
