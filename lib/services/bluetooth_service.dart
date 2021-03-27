import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/services/streaming_shared_preferences_service.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as BluetoothEnable;

class BluetoothService{
  FlutterBlue flutterBlue  = FlutterBlue.instance;
  List<BluetoothDevice> allDevices = [];
  StreamingSharedPreferencesService streamingSharedPreferencesService =
  locator<StreamingSharedPreferencesService>();

  Future<bool> enableBluetooth() async{
      return await BluetoothEnable.FlutterBluetoothSerial.instance.requestEnable();
  }

  Future<List<BluetoothDevice>> startScanningDevices() async{
    await flutterBlue.startScan(timeout: Duration(seconds: 6));
    print("Bluetooth scan started----");
    // flutterBlue.connectedDevices
    //     .asStream()
    //     .listen((List<BluetoothDevice> devices) {
    // for (BluetoothDevice device in devices) {
    //   print(device.name + "connected devices-" + device.id.toString());
    //   allDevices.add(device);
    // }});
    Future<List<BluetoothDevice>> _connectedDevices = flutterBlue.connectedDevices;
    flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
      print(r.device.name+'${r.device.id.toString()} found! total devices found: ${results.length}');
      allDevices.add(r.device);
    }
    print("List of all available devices------"+allDevices.toString());
    });
    
  }
  void stopScanningDevices() async{
    await flutterBlue.stopScan();
  }
  void connectDevice(BluetoothDevice device) async{
    await device.connect();
    print("device connected----");
  }
}