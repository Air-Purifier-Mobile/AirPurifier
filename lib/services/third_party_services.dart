import 'package:air_purifier/services/firestore_service.dart';
import 'package:air_purifier/services/mqtt_service.dart';
import 'package:air_purifier/services/phone_auth_service.dart';
import 'package:air_purifier/services/rgbColor_service.dart';
import 'package:air_purifier/services/streaming_shared_preferences_service.dart';
import 'package:air_purifier/services/wifi_service.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:air_purifier/services/authentication_service.dart';
import 'package:air_purifier/services/bluetooth_service.dart';

@module
abstract class ThirdPartyServicesModule {
  @lazySingleton
  NavigationService get navigationService;

  @lazySingleton
  DialogService get dialogService;

  @lazySingleton
  AuthenticationService get authenticationService;

  @lazySingleton
  BluetoothService get bluetoothService;

  @lazySingleton
  WifiService get wifiService;

  @lazySingleton
  StreamingSharedPreferencesService get streamingSharedPreferencesService;

  @lazySingleton
  FirestoreService get firestoreService;

  @lazySingleton
  MqttService get mqttService;

  @lazySingleton
  RGBService get rgbService;

  @lazySingleton
  PhoneAuthenticationService get phoneAuthenticationService;
}
