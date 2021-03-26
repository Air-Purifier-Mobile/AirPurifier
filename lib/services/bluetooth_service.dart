import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothService{
  // Initializing the Bluetooth connection state to be unknown
  BluetoothState bluetoothState = BluetoothState.UNKNOWN;

  // Get the instance of the Bluetooth
  final FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  // Track the Bluetooth connection with the remote device
  BluetoothConnection connection;

  // This member variable will be used for tracking
  // the Bluetooth device connection state
  int deviceState;

  // Define a member variable to track
  // when the disconnection is in progress
  bool isDisconnecting = false;

  // To track whether the device is still connected to Bluetooth
  bool isConnected;

  List<BluetoothDevice> devicesList = [];

  List<DropdownMenuItem<BluetoothDevice>> items = [];

  BluetoothDevice connectedDevice;

  void initState(){

    if(connection != null && connection.isConnected)
      isConnected = true;
    else isConnected = false;

    // neutral state
    deviceState = 0;

    // If the Bluetooth of the device is not enabled,
    // then request permission to turn on Bluetooth
    // as the app starts up
    enableBluetooth();

    // stream keeps listening for changes in state
    bluetooth.onStateChanged().listen((event) {
      bluetoothState = event;
    });

    // For retrieving the paired devices list
    getPairedDevices();
  }

  Future<void> enableBluetooth() async {
    if (bluetoothState != BluetoothState.STATE_ON) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      print("-------Error-------");
    }
    // Store the [devices] list in the [devicesList] for accessing
    // the list outside this class
    devicesList = devices;
    print(devicesList.toString());
    connect(devicesList[0]);
  }

  void dispose(){
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }
  }

  void connect(BluetoothDevice _deviceToConnect) async{
    await BluetoothConnection.toAddress(_deviceToConnect.address)
        .then((value) {
      connection = value;
      isConnected = true;
      connection.input.listen(null).onDone(() {
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }});
    }).catchError((error) {
      print('Cannot connect, exception occurred');
      print(error);
    });
    print('----------Device connected------------'+_deviceToConnect.name);
  }

  void disconnect() async {
    // Closing the Bluetooth connection
    await connection.close();
    print('----------Device disconnected---------');

    // Update the [_connected] variable
    if (!connection.isConnected) {
      isConnected = false;
    }
  }


}