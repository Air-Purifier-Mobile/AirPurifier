import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart'
    as BluetoothEnable;

class BluetoothService {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> allDevices = [];
  // StreamingSharedPreferencesService streamingSharedPreferencesService =
  //     locator<StreamingSharedPreferencesService>();

  Future<bool> enableBluetooth() async {
    return await BluetoothEnable.FlutterBluetoothSerial.instance
        .requestEnable();
  }

  void startScanningDevices(Function callBack) async {
    print("Bluetooth scan started----");
    flutterBlue.startScan(timeout: Duration(seconds: 5)).asStream().listen(
        (event) {
      // print("Scan function return" + event.toString() + "------------");
      // print("\n\n");
      // print(event.runtimeType.toString());
    }, onError: (error) {
      callBack("There was some error in searching devices.");
    }).onData((data) {
      data.forEach((result) {
        print(
            "Scan function data : " + data.length.toString() + "------------");
        print("\n\n");
        print(data.runtimeType.toString());
        allDevices.add(result.device);
        callBack("Got Devices. Now Connecting to Air Purifier.");
        stopScanningDevices();
      });
    });
  }

  void stopScanningDevices() async {
    await flutterBlue.stopScan();
  }

  void connectDevice(BluetoothDevice device) async {
    await device.connect();
    print("device connected----");
  }
}
