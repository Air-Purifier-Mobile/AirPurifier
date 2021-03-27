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

  void init(Function callback) {
    connection.input.listen((event) {}).onData((utfData) {
      String response = utf8.decode(utfData);
      callback(response, response == "OK");
    });
  }

  Future<bool> enableBluetooth() async {
    return await flutterBluetoothSerial.requestEnable();
  }

  void startScanningDevices(Function callBack) async {
    print("Bluetooth scan started----");
    _streamSubscription =
        flutterBluetoothSerial.startDiscovery().listen((event) {
      callBack('Searching for Air Purifier', false);
      allDevices.add(event);
    }, onError: (error) {
      callBack('Error on discovery' + error.toString(), false);
    });
    _streamSubscription.onDone(() {
      stopScanningDevices();
      bool isPurifier = false;
      allDevices.forEach((r) {
        print("Name----" + r.device.name);
        if (r.device.name == 'Airpurifier') {
          connectDevice(r.device, callBack);
          isPurifier = true;
          callBack('Air Purifier Found ' + r.device.address, false);
        } else {
          callBack('Device-' + r.device.name, false);
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
    Function callback,
  ) async {
    connectedDevice = device;
    callback("Connecting to Device : ${device.name}", false);
    await BluetoothConnection.toAddress(device.address).then((_connection) {
      connection = _connection;
      init(callback);
      _connection.isConnected
          ? callback("Device Connected SuccessFully", false)
          : callback("Purifier Not Connected", false);
      Future.delayed(Duration(seconds: 3), () {
        sendMessage();
      });
    }).onError((error, stackTrace) =>
        callback("Device Connection Failed " + error.toString(), false));
  }

  void sendMessage() async {
    print('Sending AT to device');
    // callback('Sending AT to device. Waiting for response');
    connection.output.add(utf8.encode("AT"));
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
