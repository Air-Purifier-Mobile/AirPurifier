import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/app/router.gr.dart';
import 'package:air_purifier/services/authentication_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddDeviceViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  void goToBluetoothScreen() {
    _navigationService.navigateTo(Routes.bluetoothDiscoveryView);
  }

  void goToLoginScreen() {
    _authenticationService.signOut();
    _navigationService.clearStackAndShow(Routes.loginView);
  }
}
