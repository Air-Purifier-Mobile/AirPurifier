import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BluetoothService {

  FlutterBluetoothSerial flutterBluetoothSerial = FlutterBluetoothSerial.instance;
  BluetoothDevice connectedDevice;
  List<BluetoothDiscoveryResult> allDevices = [];
  StreamSubscription _streamSubscription;
  BluetoothConnection connection;

  void init(){
    connection.input.listen(_receiveMessage).onDone(() {
        print("init ran------");
    });
  }

  Future<bool> enableBluetooth() async {
    return await flutterBluetoothSerial
        .requestEnable();
  }

  void startScanningDevices(Function callBack) async {
      print("Bluetooth scan started----");
      _streamSubscription = flutterBluetoothSerial.startDiscovery().listen((event) {
        callBack('Searching for Air Purifier');
        allDevices.add(event);
      },onError: (error){
        callBack('Error on discovery'+error.toString());
      });
      _streamSubscription.onDone(() {
        stopScanningDevices();
        bool isPurifier = false;
        allDevices.forEach((r) {
          print("Name----"+r.device.name);
          if(r.device.name == 'Airpurifier') {
            connectDevice(r.device, callBack);
            isPurifier = true;
            callBack('Air Purifier Found '+r.device.address);
          }
          else{
            callBack('Device-'+r.device.name);
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
    callback("Connecting to Device : ${device.name}");
    await BluetoothConnection.toAddress(device.address)
        .then((_connection) {
          connection = _connection;
          init();
      _connection.isConnected
          ? callback("Device Connected SuccessFully")
          : callback("Purifier Not Connected");
          Future.delayed(Duration(seconds: 3),
              () {
              sendMessage(callback);
              });
    }).onError((error, stackTrace) =>
            callback("Device Connection Failed "+error.toString()));
  }
  void sendMessage(Function callback) async{
    print('Sending AT to device');
    // callback('Sending AT to device. Waiting for response');
    connection.output.add(utf8.encode("AT"));
    await connection.output.allSent;
  }
  void _receiveMessage(Uint8List data) async{
    Fluttertoast.showToast(msg: ''+utf8.decode(data));
  }
}
