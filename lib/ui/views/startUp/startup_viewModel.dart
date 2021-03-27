import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/app/router.gr.dart';
import 'package:stacked/stacked.dart';
import 'package:air_purifier/services/authentication_service.dart';
import 'package:stacked_services/stacked_services.dart';

class StartUpViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  void onModelReady() {
    Future.delayed(
      Duration(seconds: 0),
      () {
        _authenticationService.getLogInStatus()
            ? _navigationService.replaceWith(Routes.bluetoothView)
            : _navigationService.replaceWith(Routes.loginView);
      },
    );
  }
}
