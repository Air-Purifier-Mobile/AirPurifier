// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:stacked_services/stacked_services.dart' as _i5;

import '../services/authentication_service.dart' as _i3;
import '../services/bluetooth_service.dart' as _i4;
import '../services/third_party_services.dart'
    as _i6; // ignore_for_file: unnecessary_lambdas

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
  gh.lazySingleton<_i5.NavigationService>(
      () => thirdPartyServicesModule.navigationService);
  return get;
}

class _$ThirdPartyServicesModule extends _i6.ThirdPartyServicesModule {
  @override
  _i3.AuthenticationService get authenticationService =>
      _i3.AuthenticationService();
  @override
  _i4.BluetoothService get bluetoothService => _i4.BluetoothService();
  @override
  _i5.DialogService get dialogService => _i5.DialogService();
  @override
  _i5.NavigationService get navigationService => _i5.NavigationService();
}
