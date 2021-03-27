import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart'
    as serialBluetooth;

class BluetoothService {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  // StreamingSharedPreferencesService streamingSharedPreferencesService =
  //     locator<StreamingSharedPreferencesService>();
  BluetoothDevice connectedDevice;
  Future<bool> enableBluetooth() async {
    return await serialBluetooth.FlutterBluetoothSerial.instance
        .requestEnable();
  }

  void startScanningDevices(Function callBack) async {
    print("Bluetooth scan started----");
    flutterBlue.startScan(timeout: Duration(seconds: 5)).asStream().listen(
        (event) {
      // print("Scan function return" + event.toString() + "------------");
      // print("\n\n");
      // print(event.runtimeType.toString());
    }, onError: (error) {
      callBack("There was some error in searching devices.");
    }).onData((data) {
      callBack("Stopping Scanning Devices");
      stopScanningDevices();
      bool gotDevice = false;
      data.forEach((result) {
        print("Scan function data : " + result.device.name + "------------");
        print(data.runtimeType.toString());
        if (result.device.name == "Airpurifier") {
          connectDevice(result.device, callBack);
          gotDevice = true;
        }
      });
      if (!gotDevice) {
        callBack("Device named 'Airpurifier' Not Found");
      }
    });
  }

  void stopScanningDevices() async {
    print("Stopped Scanning Devices");
    await flutterBlue.stopScan();
  }

  void connectDevice(
    BluetoothDevice device,
    Function callback,
  ) async {
    connectedDevice = device;
    callback("Connecting to Device : ${device.name}");
    await serialBluetooth.BluetoothConnection.toAddress(device.id.id)
        .then((_connection) {
      _connection.isConnected
          ? callback("Device Connected SuccessFully")
          : callback("Device Not Connected");
    }).onError((error, stackTrace) =>
            callback("Device Connection FAiled due to some reasons"));
    // await device.connect().onError((error, stackTrace) {
    //   callback(error.toString());
    // });
  }

  void getServices() {
    // serialBluetooth.
  }
}
