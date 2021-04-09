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
          if (response.trim() == selectedSSID) {
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
          if (response.trim() == "OK") {
            macResponse = true;
            testCommandSent = false;
            Future.delayed(Duration(milliseconds: 500), () {
              changeDisplayText("Received test response. Retrieving mac.");
              sendCommand("+MAC?\r\n");
            });
          }
          if (response.trim() == "WIFI CONNECTED") {
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
          if (response.trim() == "WIFI FAIL") {
            failedResponseCount++;
            selectedSSID = '';
            password = '';
            changeToWifiScreen(true);
            Fluttertoast.showToast(
                msg:
                    "Device failed to connect to wifi. Restarting configuration");
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
    changeDisplayText('Searching for Air Purifier. Please wait.');
    _streamSubscription =
        flutterBluetoothSerial.startDiscovery().listen((event) {
      allDevices.add(event);
    }, onError: (error) {
      changeDisplayText(
          "Fetching bluetooth devices failed.\n Restart application.");
    });
    _streamSubscription.onDone(() {
      bool deviceFound = false;
      for (int i = 0; i < allDevices.length; i++) {
        if (allDevices[i].device.name == 'Airpurifier') {
          changeDisplayText('Air Purifier Found.');
          stopScanningDevices();
          connectDevice(allDevices[i].device);
          deviceFound = true;
          break;
        }
      }
      if (!deviceFound) {
        changeDisplayText('No Air Purifier Found. Scanning again.');
        startScanningDevices();
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
    if (device.isBonded) {
      // Un-pair the device
      FlutterBluetoothSerial.instance
          .removeDeviceBondWithAddress(device.address)
          .then((result) {
        if (result) {
          // Re-pair  the device
          FlutterBluetoothSerial.instance
              .bondDeviceAtAddress(device.address)
              .then((pairResult) {
            if (pairResult) {
              BluetoothConnection.toAddress(device.address).then((_connection) {
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
              }).onError((error, stackTrace) {
                _firestoreService.storeResponses(
                  uid: "StackTrace2",
                  mac: "${error.toString()} +  ${stackTrace.toString()}",
                );
                changeDisplayText(
                  "Air Purifier refused to connect. Please restart the application.",
                );
              });
            } else {
              changeDisplayText(
                  "Please restart application to complete pairing process");
            }
          });
        } else {
          changeDisplayText(
              "Please un-pair the device manually from phone bluetooth settings and refresh");
          // connectDevice(device);
        }
      });
      // Fluttertoast.showToast(msg: "Device already paired");
      // BluetoothConnection.toAddress(device.address).then((_connection) {
      //   connection = _connection;
      //   if (_connection.isConnected) {
      //     connectedDevice = device;
      //     changeDisplayText("Connected to Device : ${device.name}");
      //     Future.delayed(Duration(milliseconds: 500), () {
      //       sendTestMessage();
      //       startListeningFromDevice();
      //     });
      //   } else
      //     changeDisplayText(
      //         "Purifier Not Connected.\nPlease restart application.");
      // }).onError((error, stackTrace) {
      //   _firestoreService.storeResponses(
      //     uid: "StackTrace1",
      //     mac: "${error.toString()} +  ${stackTrace.toString()}",
      //   );
      //   changeDisplayText(
      //     "Air Purifier refused to connect. Please restart the application.",
      //   );
      // });
    } else {
      FlutterBluetoothSerial.instance
          .bondDeviceAtAddress(device.address)
          .then((pairResult) {
        if (pairResult) {
          BluetoothConnection.toAddress(device.address).then((_connection) {
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
                  "Purifier Not Connected.\nPlease refresh application.");
          }).onError((error, stackTrace) {
            _firestoreService.storeResponses(
              uid: "StackTrace2",
              mac: "${error.toString()} +  ${stackTrace.toString()}",
            );
            changeDisplayText(
              "Air Purifier refused to connect. Please refresh the application.",
            );
          });
        } else {
          changeDisplayText(
              "Please refresh application to complete pairing process");
        }
      });
    }
  }

  int okCounter = 0;
  void sendTestMessage() async {
    changeDisplayText("Testing Connection $okCounter");
    connection.output.add(utf8.encode("AT\r\n"));
    await connection.output.allSent;
    testCommandSent = true;
    Future.delayed(Duration(seconds: 3), () {
      if (testCommandSent) {
        // error
        okCounter++;
        connection.dispose();
        connectDevice(connectedDevice);
      }
    });
  }

  void sendCommand(String command) async {
    if (connection.isConnected) {
      connection.output.add(utf8.encode(command));
      await connection.output.allSent;
    } else {
      connection.dispose();
      changeDisplayText("Device disconnected arbitrarily. Please Wait.");
      connectDevice(connectedDevice);
    }
  }
}
