import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
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
  void init() {
    //Went to Beta
    try {
      connection.input.listen((event) {}).onData((utfData) {
        String response = utf8.decode(utfData).toString();
        _firestoreService.storeResponses(
          uid: "Responses $messageOrder",
          mac: response,
        );
        messageOrder++;
        // changeDisplayText(response);
        // Fluttertoast.showToast(msg: "Device Response: " + response);
        if (startReadingJson || response.contains('\$')) {
          if (!response.contains('\$')) {
            _firestoreService.storeResponses(
                uid: "Inside first IF $counter", mac: _buffer);
            counter++;
            _buffer = _buffer + response;
          } else if (startReadingJson) {
            if (response.length > 1) {
              _buffer = (_buffer + response).trim();
              _buffer = _buffer.substring(0, _buffer.length - 1).trim();
            }
            changeDisplayText("buffer-" + _buffer);
            startReadingJson = false;
            String temp = _buffer;
            _buffer = '';
            jsonMap = jsonDecode(temp);
            updateSSIDListCallback(jsonMap['SSID']);
            changeToWifiScreen();
          } else
            startReadingJson = true;
        }
        if (response == "" || response == " ") {
          Fluttertoast.showToast(
              msg: "Received spaces or empty String in message");
        }
        if (password != null && response == password) {
          changeDisplayText("Password Set In device");
          sendCommand("+CONNECT\r\n");
        }
        if (response == "OK") {
          changeDisplayText("Sending command to fetch SSIDs");
          sendCommand("+SCAN?\r\n");
        }
        if (response == "WIFI CONNECTED") {
          changeDisplayText("Device Connected To $selectedSSID");
          macResponse = true;
          sendCommand("+MAC?\r\n");
        }
        if (response == "WIFI FAIL") {
          changeDisplayText("Device failed to Connect to $selectedSSID");
          failedResponseCount++;
          if (failedResponseCount == 15) {
            changeToBluetoothScreen();
            connection.dispose();
            changeDisplayText(
                "Restarting Device...\nRefresh when device ready to connect.");
          }
        }
        if (macResponse) {
          changeDisplayText("MAC of device Saved in Shared Preferences");
          _firestoreService.storeUserData(
              uid: _authenticationService.getUID(), mac: response.trim());
          _streamingSharedPreferencesService.changeStringInStreamingSP(
              "MAC", response.trim());
          _navigationService.clearStackAndShow(Routes.homeView);
        }
        // else {
        // try {
        //   temp = jsonDecode(response);
        //   Fluttertoast.showToast(msg: 'json decode ran');
        //   changeDisplayText(temp.toString());
        //   if (temp.containsKey("Total_SSID")) {
        //     updateSSIDListCallback(temp["SSID"]);
        //     changeDisplayText('Length of list'+temp['SSID'].length);
        //     changeToWifiScreen();
        //   }
        //   else{
        //     updateSSIDListCallback(temp["SSID"]);
        //     //changeDisplayText('Length of list'+temp['SSID'].length);
        //     changeToWifiScreen();
        //   }
        //   changeDisplayText('Error in parsing');
        // } catch (error) {
        //   if (response == password) {
        //   changeDisplayText("Password Set In device");
        //   sendCommand("+CONNECT\r\n");
        // }
        //    else if (response == selectedSSID) {
        //   } else {
        //     Future.delayed(Duration(seconds: 2),(){
        //       _streamingSharedPreferencesService.changeStringInStreamingSP(
        //         "MAC_ID",
        //         response,
        //       );
        //       changeDisplayText("MAC ID of Device is: ${error.toString()}");
        //       //_firestoreService.storeUserData(uid: _authenticationService.getUID(), mac: response);
        //     });
        //   }
        // }
        // }
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

  void sendCommand(String command) async {
    connection.output.add(utf8.encode(command));
    await connection.output.allSent;
  }
}
