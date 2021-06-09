// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:stacked_services/stacked_services.dart' as _i5;
import '../services/authentication_service.dart' as _i3;
import '../services/bluetooth_service.dart' as _i4;
import '../services/firestore_service.dart' as _i6;
import '../services/mqtt_service.dart' as _i7;
import '../services/rgbColor_service.dart' as _i8;
import '../services/streaming_shared_preferences_service.dart' as _i9;
import '../services/third_party_services.dart' as _i12;
import '../services/wifi_service.dart'
    as _i10; // ignore_for_file: unnecessary_lambdas
import '../services/phone_auth_service.dart' as _i11;

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String environment, _i2.EnvironmentFilter environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final thirdPartyServicesModule = _$ThirdPartyServicesModule();
  gh.lazySingleton<_i3.AuthenticationService>(
      () => thirdPartyServicesModule.authenticationService);
  gh.lazySingleton<_i4.BluetoothService>(
      () => thirdPartyServicesModule.bluetoothService);
  gh.lazySingleton<_i5.DialogService>(
      () => thirdPartyServicesModule.dialogService);
  gh.lazySingleton<_i6.FirestoreService>(
      () => thirdPartyServicesModule.firestoreService);
  gh.lazySingleton<_i7.MqttService>(() => thirdPartyServicesModule.mqttService);
  gh.lazySingleton<_i5.NavigationService>(
      () => thirdPartyServicesModule.navigationService);
  gh.lazySingleton<_i8.RGBService>(() => thirdPartyServicesModule.rgbService);
  gh.lazySingleton<_i9.StreamingSharedPreferencesService>(
      () => thirdPartyServicesModule.streamingSharedPreferencesService);
  gh.lazySingleton<_i10.WifiService>(
      () => thirdPartyServicesModule.wifiService);
  gh.lazySingleton<_i11.PhoneAuthenticationService>(
          () => thirdPartyServicesModule.phoneAuthenticationService);
  return get;
}

class _$ThirdPartyServicesModule extends _i12.ThirdPartyServicesModule {
  @override
  _i3.AuthenticationService get authenticationService =>
      _i3.AuthenticationService();
  @override
  _i4.BluetoothService get bluetoothService => _i4.BluetoothService();
  @override
  _i5.DialogService get dialogService => _i5.DialogService();
  @override
  _i6.FirestoreService get firestoreService => _i6.FirestoreService();
  @override
  _i7.MqttService get mqttService => _i7.MqttService();
  @override
  _i5.NavigationService get navigationService => _i5.NavigationService();
  @override
  _i8.RGBService get rgbService => _i8.RGBService();
  @override
  _i9.StreamingSharedPreferencesService get streamingSharedPreferencesService =>
      _i9.StreamingSharedPreferencesService();
  @override
  _i10.WifiService get wifiService => _i10.WifiService();
  @override
  _i11.PhoneAuthenticationService get phoneAuthenticationService =>
      _i11.PhoneAuthenticationService();
}
