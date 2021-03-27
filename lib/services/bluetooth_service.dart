import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/app/router.gr.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked_services/stacked_services.dart';

class BluetoothService {
  FlutterBluetoothSerial flutterBluetoothSerial =
      FlutterBluetoothSerial.instance;
  BluetoothDevice connectedDevice;
  List<BluetoothDiscoveryResult> allDevices = [];
  StreamSubscription _streamSubscription;
  BluetoothConnection connection;
  NavigationService _navigationService = locator<NavigationService>();
  Function changeDisplayText;
  Function changeToWifiScreen;

  void init() {
    connection.input.listen((event) {
      Fluttertoast.showToast(msg: "Device Response: " + utf8.decode(event));
    }).onData((utfData) {
      String response = utf8.decode(utfData);
      changeDisplayText(response);
      if (response == "OK") {
        changeToWifiScreen();
      }
    });
  }

  Future<bool> enableBluetooth(
      Function changeDisplayCallBack, Function goToWifi) async {
    changeDisplayText = changeDisplayCallBack;
    changeToWifiScreen = goToWifi;
    return await flutterBluetoothSerial.requestEnable();
  }

  void startScanningDevices() async {
    print("Bluetooth scan started----");
    _streamSubscription =
        flutterBluetoothSerial.startDiscovery().listen((event) {
      changeDisplayText('Searching for Air Purifier');
      allDevices.add(event);
    }, onError: (error) {
      changeDisplayText('Error on discovery' + error.toString());
    });
    _streamSubscription.onDone(() {
      stopScanningDevices();
      allDevices.forEach((r) {
        print("Name----" + r.device.name);
        if (r.device.name == 'Airpurifier') {
          connectDevice(r.device);
          changeDisplayText('Air Purifier Found ' + r.device.address);
        }
      });
    });
  }

  void stopScanningDevices() async {
    print("Stopped Scanning Devices");
    _streamSubscription.cancel();
    //await flutterBluetoothSerial.cancelDiscovery();
  }

  void connectDevice(
    BluetoothDevice device,
  ) async {
    connectedDevice = device;
    changeDisplayText("Connecting to Device : ${device.name}");
    await BluetoothConnection.toAddress(device.address).then((_connection) {
      connection = _connection;
      _connection.isConnected
          ? changeDisplayText("Device Connected SuccessFully")
          : changeDisplayText("Purifier Not Connected");
      sendMessage();
      init();
    }).onError((error, stackTrace) =>
        changeDisplayText("Device Connection Failed " + error.toString()));
  }

  void sendMessage() async {
    print('Sending AT to device');
    changeDisplayText('Sending AT to device. Waiting for response');
    connection.output.add(utf8.encode("AT\r\n"));
    await connection.output.allSent;
  }

  // void _receiveMessage(Uint8List data) async {
  //   Fluttertoast.showToast(msg: '' + utf8.decode(data));
  //   // Future.delayed(Duration(seconds: 2), () {
  //   //   _navigationService.replaceWith(Routes.wifiView);
  //   // });
  // }

  void sendCommand(String command) async {
    connection.output.add(utf8.encode(command));
    await connection.output.allSent;
  }
}
