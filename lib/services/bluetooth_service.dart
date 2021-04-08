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
  String password = '';
  String selectedSSID = '';
  int failedResponseCount = 0;
  Map<String, dynamic> jsonMap;
  bool startReadingJson = false;
  bool macResponse = false;
  int messageOrder = 0;
  int counter = 0;
  int testCommandCounter = 0;
  bool testCommandSent = false;
  List<String> allWifiDevices = [];

  void startListeningFromDevice() {
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
              allWifiDevices.add(response.trim());
            else if (response.contains('\$' * 40)) startReadingJson = true;
          }
          if (response == selectedSSID) {
            changeDisplayText("SSID response registered");
          }
          if (password != null && response == password) {
            changeDisplayText("Password Set In device");
            Future.delayed(Duration(milliseconds: 500), () {
              sendCommand("+CONNECT\r\n");
            });
          }
          if (macResponse) {
            changeDisplayText("MAC of device Saved in Shared Preferences");
            _streamingSharedPreferencesService.changeStringInStreamingSP(
              "MAC",
              response.trim(),
            );
            changeDisplayText("Sending command to fetch SSIDs");
            macResponse = false;
            Future.delayed(Duration(milliseconds: 500), () {
              sendCommand("+SCAN?\r\n");
            });
          }
          if (response == "OK") {
            macResponse = true;
            testCommandSent = false;
            Future.delayed(Duration(milliseconds: 500), () {
              sendCommand("+MAC?\r\n");
            });
          }
          if (response == "WIFI CONNECTED") {
            changeDisplayText("Device Connected To $selectedSSID");
            _firestoreService.storeUserData(
              uid: _authenticationService.getUID(),
              mac: _streamingSharedPreferencesService
                  .readStringFromStreamingSP('MAC'),
            );
            selectedSSID = '';
            password = '';
            connection.dispose();
            _navigationService.clearStackAndShow(Routes.homeView);
          }
          if (response == "WIFI FAIL") {
            changeDisplayText("Device failed to Connect to $selectedSSID");
            failedResponseCount++;
            selectedSSID = '';
            password = '';
            Future.delayed(Duration(milliseconds: 500), () {
              changeDisplayText(
                  "Device failed to connect to wifi. Restarting configuration");
            });
            Future.delayed(Duration(milliseconds: 1000), () {
              changeToWifiScreen();
            });
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
    changeDisplayText('Searching for Air Purifier. Please wait.');
    _streamSubscription =
        flutterBluetoothSerial.startDiscovery().listen((event) {
      allDevices.add(event);
    }, onError: (error) {
      changeDisplayText(
          "Fetching bluetooth devices failed.\n Restart application.");
    });
    _streamSubscription.onDone(() {
      stopScanningDevices();
      bool deviceFound = false;
      for (int i = 0; i < allDevices.length; i++) {
        print("Name----" + allDevices[i].device.name);
        if (allDevices[i].device.name == 'Airpurifier') {
          connectDevice(allDevices[i].device);
          deviceFound = true;
          changeDisplayText('Air Purifier Found.');
        }
      }
      if (!deviceFound) {
        deviceFound = false;
        changeDisplayText('No Air Purifier Found. Please refresh.');
      }
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
    await BluetoothConnection.toAddress(device.address).then((_connection) {
      connection = _connection;
      if (_connection.isConnected) {
        connectedDevice = device;
        changeDisplayText("Connected to Device : ${device.name}");
        Future.delayed(Duration(milliseconds: 500), () {
          sendTestMessage();
          startListeningFromDevice();
        });
      } else
        changeDisplayText(
            "Purifier Not Connected.\nPlease restart application.");
    }).onError((error, stackTrace) => changeDisplayText(
        "Air Purifier refused to connect. Please restart the application."));
  }

  void sendTestMessage() async {
    changeDisplayText("Testing Connection");
    connection.output.add(utf8.encode("AT\r\n"));
    await connection.output.allSent;
    testCommandSent = true;
    Future.delayed(Duration(seconds: 2), () {
      if (testCommandSent) {
        ///error
        if (testCommandCounter < 5)
          sendTestMessage();
        else {
          testCommandCounter = 0;
          changeDisplayText("Device Communication Error.\nRefresh Bluetooth");
        }
        testCommandCounter++;
      }
    });
  }

  void sendCommand(String command) async {
    connection.output.add(utf8.encode(command));
    await connection.output.allSent;
  }
}
