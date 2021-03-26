import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/services/bluetooth_service.dart';
import 'package:stacked/stacked.dart';

class BluetoothViewModel extends BaseViewModel {
  final BluetoothService bluetoothService = locator<BluetoothService>();

  void onModelReady(){
    bluetoothService.initState();

  }
}
