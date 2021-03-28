import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/app/router.gr.dart';
import 'package:air_purifier/services/streaming_shared_preferences_service.dart';
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
  StreamingSharedPreferencesService _streamingSharedPreferencesService =
      locator<StreamingSharedPreferencesService>();
  Function changeDisplayText;
  Function changeToWifiScreen;
  Function updateSSIDListCallback;
  Function changeToBluetoothScreen;
  String password;
  String selectedSSID;
  int failedResponseCount = 0;
  var temp;

  void init() {
    try {
      connection.input.listen((event) {}).onData((utfData) {
        String response = utf8.decode(utfData);
        changeDisplayText(response);
        Fluttertoast.showToast(msg: "Device Response: " + response);
        if (response == "OK") {
          changeDisplayText("Sending command to fetch SSIDs");
          sendCommand("+SCAN?\r\n");
        } else if (response == "WIFI CONNECTED") {
          changeDisplayText("Device Connected To $selectedSSID");
          sendCommand("+MAC?\r\n");
        } else if (response == "WIFI FAIL") {
          changeDisplayText("Device failed to Connect to $selectedSSID");
          failedResponseCount++;
          if (failedResponseCount == 15) {
            changeToBluetoothScreen();
            connection.dispose();
            changeDisplayText(
                "Restarting Device...\nRefresh when device ready to connect.");
          }
        } else {
          try {
            temp = jsonDecode(response);
            if (temp.containsKey("Total_SSID")) {
              updateSSIDListCallback(temp["SSID"]);
              changeToWifiScreen();
            }
          } catch (error) {
            if (response == password) {
              changeDisplayText("Password Set In device");
              sendCommand("+CONNECT\r\n");
            } else if (response == selectedSSID) {
            } else {
              _streamingSharedPreferencesService.changeStringInStreamingSP(
                "MAC_ID",
                response,
              );
              changeDisplayText("MAC ID of Device is: $response");
            }
          }
        }
      });
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Error in Listening device response" + error.toString());
    }
  }

  Future<bool> enableBluetooth(
    Function changeDisplayCallBack,
    Function goToWifi,
    Function updateSSIDList,
    Function goToBluetoothCallback,
  ) async {
    changeDisplayText = changeDisplayCallBack;
    changeToWifiScreen = goToWifi;
    changeToBluetoothScreen = goToBluetoothCallback;
    updateSSIDListCallback = updateSSIDList;
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
