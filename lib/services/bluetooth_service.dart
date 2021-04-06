import 'dart:async';
import 'dart:convert';
import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/app/router.gr.dart';
import 'package:air_purifier/services/authentication_service.dart';
import 'package:air_purifier/services/firestore_service.dart';
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
  NavigationService _navigationService = locator<NavigationService>();
  StreamingSharedPreferencesService _streamingSharedPreferencesService =
      locator<StreamingSharedPreferencesService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  FirestoreService _firestoreService = locator<FirestoreService>();
  Function changeDisplayText;
  Function changeToWifiScreen;
  Function updateSSIDListCallback;
  Function changeToBluetoothScreen;
  String password;
  String selectedSSID;
  int failedResponseCount = 0;
  Map<String, dynamic> jsonMap;
  String _buffer = '';
  bool startReadingJson = false;
  bool macResponse = false;
  int messageOrder = 0;
  int counter = 0;
  List<String> allWifiDevices = [];

  void init() {
    //Went to Beta
    try {
      connection.input.listen((event) {}).onData((utfData) {
        String response = utf8.decode(utfData).toString();
        if (response != "" &&
            response != "\r\n" &&
            response != "\n" &&
            response != "\r" &&
            response != " " &&
            response != " \r\n") {
          _firestoreService.storeResponses(
            uid: "Responses $messageOrder",
            mac: response,
          );
          messageOrder++;
          // changeDisplayText(response);
          // Fluttertoast.showToast(msg: "Device Response: " + response);

          if (startReadingJson || response.contains('\$' * 40)) {
            if (response.contains('\#' * 40)) {
              startReadingJson = false;
              changeDisplayText(allWifiDevices.toString());
              _firestoreService.storeResponses(
                uid: "Responses Final list",
                mac: allWifiDevices.toString(),
              );
              updateSSIDListCallback(allWifiDevices);
              changeToWifiScreen();
            }
            if (startReadingJson)
              allWifiDevices.add(response);
            else if (response.contains('\$' * 40)) startReadingJson = true;
          }

          if (response == "" || response == " ") {
            Fluttertoast.showToast(
                msg: "Received spaces or empty String in message");
          }
          if (password != null && response == password) {
            changeDisplayText("Password Set In device");
            sendCommand("+CONNECT\r\n");
          }
          if (macResponse) {
            changeDisplayText("MAC of device Saved in Shared Preferences");
            _streamingSharedPreferencesService.changeStringInStreamingSP(
              "MAC",
              response.trim(),
            );
            changeDisplayText("Sending command to fetch SSIDs");
            macResponse = false;
            sendCommand("+SCAN?\r\n");
          }
          if (response == "OK") {
            macResponse = true;
            sendCommand("+MAC?\r\n");
          }
          if (response == "WIFI CONNECTED") {
            changeDisplayText("Device Connected To $selectedSSID");
            _firestoreService.storeUserData(
              uid: _authenticationService.getUID(),
              mac: _streamingSharedPreferencesService
                  .readStringFromStreamingSP('MAC'),
            );
            _navigationService.clearStackAndShow(Routes.homeView);
          }
          if (response == "WIFI FAIL") {
            changeDisplayText("Device failed to Connect to $selectedSSID");
            failedResponseCount++;
            if (true) {
              changeToBluetoothScreen();
              connection.dispose();
              changeDisplayText(
                  "Restarting Device...\nRefresh when device ready to connect.");
            }
          }
        }
      });
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error in Listening device response" + error.toString(),
      );
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
          changeDisplayText('Air Purifier Found ');
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

  void sendCommand(String command) async {
    connection.output.add(utf8.encode(command));
    await connection.output.allSent;
  }
}
