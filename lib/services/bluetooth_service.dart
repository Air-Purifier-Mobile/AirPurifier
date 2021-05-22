import 'dart:async';
import 'dart:convert';
import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/app/router.gr.dart';
import 'package:air_purifier/services/authentication_service.dart';
import 'package:air_purifier/services/firestore_service.dart';
import 'package:air_purifier/services/streaming_shared_preferences_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked_services/stacked_services.dart';

class BluetoothService {
  FlutterBluetoothSerial flutterBluetoothSerial =
      FlutterBluetoothSerial.instance;
  BluetoothDevice connectedDevice;
  String macAddress;
  List<BluetoothDiscoveryResult> allDevices = [];
  StreamSubscription _streamSubscription;
  BluetoothConnection connection;
  NavigationService _navigationService = locator<NavigationService>();
  StreamingSharedPreferencesService _streamingSharedPreferencesService =
      locator<StreamingSharedPreferencesService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  FirestoreService firestoreService = locator<FirestoreService>();
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
  bool connectedToWifiResponse = false;

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
          firestoreService.storeResponses(
            uid: "Responses $messageOrder",
            mac: response,
          );
          messageOrder++;
          if (startReadingJson || response.contains('\$' * 40)) {
            if (response.contains('\#' * 40)) {
              startReadingJson = false;
              changeDisplayText(allWifiDevices.toString());
              firestoreService.storeResponses(
                uid: "Responses Final list",
                mac: allWifiDevices.toString(),
              );
              updateSSIDListCallback(allWifiDevices);
              changeToWifiScreen(null);
            }
            if (startReadingJson)
              allWifiDevices.add(response.trim());
            else if (response.contains('\$' * 40)) startReadingJson = true;
          }
          if (response.trim() == selectedSSID) {
            changeDisplayText("SSID response registered");
          }
          if (password != null && response.trim() == password.trim()) {
            if (!checkConnectionToBluetooth()) {
              changeDisplayText(
                "Password received. If you want to change wifi then press refresh.",
              );
              Future.delayed(Duration(milliseconds: 500), () {
                Timer.periodic(Duration(seconds: 5), (timer) {
                  if (connectedToWifiResponse) {
                    timer.cancel();
                    connectedToWifiResponse = false;
                  } else {
                    sendCommand("+CONNECT\r\n");
                    firestoreService.storeResponses(
                      uid: "Responses $messageOrder",
                      mac: 'CONNECT fired',
                    );
                    messageOrder++;
                  }
                });
              });
            }
          }
          if (macResponse) {
            if (!checkConnectionToBluetooth()) {
              changeDisplayText("MAC of device Saved in Shared Preferences");
              macAddress = response.trim();
              _streamingSharedPreferencesService.changeStringInStreamingSP('tempMac', macAddress);
              changeDisplayText("Sending command to fetch SSIDs");
              macResponse = false;
              Future.delayed(Duration(milliseconds: 500), () {
                sendCommand("+SCAN?\r\n");
                firestoreService.storeResponses(
                  uid: "Responses $messageOrder $macAddress",
                  mac: 'SCAN fired',
                );
              });
            }
          }
          if (response.trim() == "OK") {
            if (checkConnectionToBluetooth()) {
              //restart connection process
            } else {
              macResponse = true;
              testCommandSent = false;
              Future.delayed(Duration(milliseconds: 500), () {
                changeDisplayText("Received test response. Retrieving mac.");
                sendCommand("+MAC?\r\n");
                firestoreService.storeResponses(
                  uid: "Responses $messageOrder",
                  mac: 'MAC fired',
                );
                messageOrder++;
              });
            }
          }
          if (response.trim() == "WIFI CONNECTED") {
            connectedToWifiResponse = true;
            changeDisplayText("Device Connected To $selectedSSID");
            firestoreService.storeResponses(
              uid: "Responses $messageOrder",
              mac: 'Wifi Connected',
            );
            messageOrder++;
            List<String> mac = _streamingSharedPreferencesService
                .readStringListFromStreamingSP("MAC");
            List<String> name = _streamingSharedPreferencesService
                .readStringListFromStreamingSP("name");
            int previousMacLength = mac.length;
            String tempMac = _streamingSharedPreferencesService.readStringFromStreamingSP('tempMac');
            mac.add(tempMac);
            mac = mac.toSet().toList();

            firestoreService.storeResponses(
              uid: "Responses $messageOrder",
              mac: 'MAC- $mac  Name- $name',
            );
            messageOrder++;

            if (mac.length != previousMacLength) {
              name.add("Device-${mac.length}");
            }

            firestoreService.storeResponses(
              uid: "Responses $messageOrder",
              mac: 'MAC length- ${mac.length}  Name- $name',
            );
            messageOrder++;

            _streamingSharedPreferencesService.changeStringListInStreamingSP(
              "MAC",
              mac,
            );
            _streamingSharedPreferencesService.changeStringListInStreamingSP(
              "name",
              name,
            );

            firestoreService.storeResponses(
              uid: "Responses $messageOrder",
              mac: 'Stored in shared pref',
            );
            messageOrder++;

            firestoreService.userData(
              FirebaseAuth.instance.currentUser.uid,
              mac,
              name,
            );

            firestoreService.storeResponses(
              uid: "Responses $messageOrder",
              mac: 'Stored in firestore user',
            );
            messageOrder++;

            selectedSSID = '';
            password = '';

            connection.dispose();
            _navigationService.clearStackAndShow(Routes.homeView);
          }
          if (response.trim() == "WIFI FAIL") {
            connectedToWifiResponse = true;
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
    changeDisplayText("Entered device is un paired");
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
          checkConnectionToBluetooth();
          firestoreService.storeResponses(
            uid: "StackTrace2",
            mac: "${error.toString()} +  ${stackTrace.toString()}",
          );
          changeDisplayText(
            "Air Purifier refused to connect. Please refresh the application.",
          );
        });
      } else {
        FlutterBluetoothSerial.instance
            .removeDeviceBondWithAddress(device.address);
        changeDisplayText(
            "Please refresh application to complete pairing process");
        connectDevice(device);
      }
    }).onError((error, stackTrace) {
      changeDisplayText(
        "Connecting to already paired device",
      );
      firestoreService.storeResponses(
        uid: "StackTrace",
        mac: "${error.toString()} +  ${stackTrace.toString()}",
      );
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
        checkConnectionToBluetooth();
        firestoreService.storeResponses(
          uid: "StackTrace2",
          mac: "${error.toString()} +  ${stackTrace.toString()}",
        );
        changeDisplayText(
          "Air Purifier refused to connect. Please refresh the application.",
        );
      });
    });
  }

  int okCounter = 0;
  void sendTestMessage() async {
    changeDisplayText("Testing Connection $okCounter");
    connection.output.add(utf8.encode("AT\r\n"));
    firestoreService.storeResponses(
      uid: "Responses $messageOrder",
      mac: 'AT fired',
    );
    messageOrder++;
    await connection.output.allSent;
    testCommandSent = true;
    Future.delayed(Duration(seconds: 5), () {
      if (testCommandSent) {
        // error
        okCounter++;
        connection.dispose();
        connectDevice(connectedDevice);
      } else {
        changeDisplayText("3 seconds over. Got response. Not sending MAC.");
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

  bool checkConnectionToBluetooth() {
    if (!connection.isConnected) {
      connection.dispose();
      changeDisplayText("Device disconnected arbitrarily. Please Wait.");
      connectDevice(connectedDevice);
      return true;
    } else
      return false;
  }
}
