import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/app/router.gr.dart';
import 'package:air_purifier/services/authentication_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends BaseViewModel {
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  NavigationService _navigationService = locator<NavigationService>();

  void login() {
    _authenticationService.signIn();
  }

  void loginWithPhone() {
    _navigationService.clearStackAndShow(Routes.phoneAuthView);
  }
}
