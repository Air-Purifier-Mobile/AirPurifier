import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/services/bluetooth_service.dart';
import 'package:stacked/stacked.dart';

class BluetoothViewModel extends BaseViewModel {
  final BluetoothService bluetoothService = locator<BluetoothService>();
  String displayText = "Please switch On the Bluetooth";

  void at() {}
  void mac() {}

  void onModelReady() {
    bluetoothService.enableBluetooth().then((isEnabled) {
      if (isEnabled) {
        displayText = "Getting Devices";
        notifyListeners();
        bluetoothService.startScanningDevices((String event) {
          displayText = event;
          notifyListeners();
        });
      }
    });
  }
}
